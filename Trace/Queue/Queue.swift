//
//  Queue.swift
//  Trace
//
//  Created by Shams Ahmed on 18/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Queue class does alot of work in database and timer such as reading/writting to disk and sending data to scheduler.
/// To avoid overloading the host app it's designed to run every so often.
internal final class Queue {
    
    // MARK: - Property
    
    static let timeout = 15
    
    internal let scheduler: Scheduler
    
    private let dispatchQueue = DispatchQueue(
        label: Constants.SDK.name.rawValue + ".Queue",
        qos: .background
    )
    private let database: Database
    private let session: Session
    private let repeater: Repeater
    
    private var lastSavedForMetric: Date = Date()
    private var lastSavedForTrace: Date = Date()
    internal var observation: ((Metrics) -> Void)?
    
    private var isMetricRequiredToBeSaved: Bool {
        let result: Bool
        let calendar = Calendar.current
        let date = Date()
        let from = lastSavedForMetric
        let components = calendar.dateComponents([.second], from: from, to: date)
        
        if let second = components.second, second >= Queue.timeout {
            result = true
        } else {
            result = false
        }
        
        return result
    }
    private var isTraceRequiredToBeSaved: Bool {
        let result: Bool
        let calendar = Calendar.current
        let date = Date()
        let from = lastSavedForTrace
        let components = calendar.dateComponents([.second], from: from, to: date)
        
        if let second = components.second, second >= Queue.timeout {
            result = true
        } else {
            result = false
        }
        
        return result
    }
    
    // MARK: - Init
    
    internal init(with scheduler: Scheduler, _ database: Database, _ session: Session) {
        self.database = database
        self.session = session
        self.scheduler = scheduler
        
        var timeout: TimeInterval = 45
        
        #if DEBUG || Debug || debug
            timeout = 30
        #endif
        
        repeater = Repeater(timeout)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let handler: () -> Void = { [weak self] in
            self?.savePendingManagedObjects()
            self?.schedule()
        }
        
        repeater.state = .resume
        repeater.handler = handler
        
        dispatchQueue.asyncAfter(
            deadline: .now() + 5,
            execute: handler
        )
    }

    // MARK: - Schedule
    
    func schedule() {
        scheduleMetrics()
        scheduleTraces()
    }
    
    func scheduleMetrics() {
        database.dao.metric.allInBackground(limit: 200) { [weak self] dbModels in
            guard !dbModels.isEmpty else { return }
            
            do {
                // DBMetric to Metric model
                let decoder = JSONDecoder()
                let metrics = try dbModels.map { try decoder.decode(Metric.self, from: $0.json as Data) }
                let combined = Dictionary(grouping: metrics, by: { $0.descriptor.name })
                    .map { key, values -> [Metric] in
                        guard key.isCollatable else { return values }
                        guard let descriptor = values.first?.descriptor else { return values }
                        
                        let timeseries = values.flatMap { $0.timeseries }
                        let collated = Metric.Collater(timeseries).collate()
                        let metric = Metric(descriptor: descriptor, timeseries: collated)
                        
                        return [metric]
                    }
                    .flatMap { $0 }
                
                func willAddResourceInScheduleMetricsMethod() { }
                func didAddResourceInScheduleMetricsMethod() { }
                
                let names = Set(combined.map { $0.descriptor.name.rawValue })
                let attributes = Trace.shared.attributes
                
                willAddResourceInScheduleMetricsMethod()
                
                let resource = self?.session.resource
                let model = Metrics(combined, resource: resource, attributes: attributes)
                let dbModelObjectIds = dbModels.map { $0.objectID }
                
                didAddResourceInScheduleMetricsMethod()
                
                Logger.debug(.queue, "Scheduling \(names.joined(separator: ", ")) from \(dbModels.count) processed metrics")
                
                self?.scheduler.schedule(model, {
                    switch $0 {
                    case .success:
                        let dao = self?.database.dao.metric
                        dao?.delete(dbModelObjectIds)
                    case .failure:
                        Logger.warning(.queue, "Failed to submit metric, will try again in 1 minute")
                    }
                })
            } catch {
                Logger.warning(.queue, "Failed to create Metric class from json: \(error)")
            }
        }
    }
    
    func scheduleTraces() {
        database.dao.trace.allInBackground(limit: 50) { [weak self] dbModels in
            guard !dbModels.isEmpty else { return }
            
            do {
                // DBTrace to Trace model
                let decoder = JSONDecoder()
                let traces = try dbModels.map { try decoder.decode(TraceModel.self, from: $0.json as Data) }
                
                guard !traces.isEmpty else { return }
                
                if dbModels.count != traces.count {
                    Logger.warning(.queue, "Converted Trace models(\(traces.count)) are not equal to the DB Models(\(dbModels.count)) counterpart.")
                }
                
                let combined = Dictionary(grouping: traces, by: { $0.resource })
                    .map { _, values -> TraceModel in
                        let combined = values[0]
                        
                        for value in values where combined.traceId != value.traceId {
                            combined.spans.append(contentsOf: value.spans)
                        }
                        
                        return combined
                    }
                
                Logger.debug(.queue, "Scheduling \(combined.count) traces")
                
                combined.forEach { trace in
                    // fallback
                    if trace.resource == nil {
                        func willAssignResourceInBlock() { }
                        
                        willAssignResourceInBlock()
                        
                        if let newResource = self?.session.resource {
                            func didAssignResourceInBlock() { }
                            
                            trace.resource = newResource
                            
                            didAssignResourceInBlock()
                        } else {
                            func didNotAssignResourceInBlock() { }
                            
                            didNotAssignResourceInBlock()
                            
                            Logger.debug(.internalError, "Resource missing from new trace model")
                        }
                    }
                    
                    let ids = Set(trace.spans.map { $0.traceId })
                    let toBeDeleted = dbModels.filter { ids.contains($0.traceId) }
                    let toBeDeletedObjectIds = toBeDeleted.map { $0.objectID }
                
                    self?.scheduler.schedule(trace, {
                        switch $0 {
                        case .success:
                            let dao = self?.database.dao.trace
                            dao?.delete(toBeDeletedObjectIds)
                        case .failure:
                            Logger.warning(.queue, "Failed to submit trace, will try again in 1 minute")
                        }
                    })
                }
            } catch {
                Logger.warning(.queue, "Failed to create Trace class from json: \(error)")
            }
        }
    }
    
    // MARK: - Add
    
    internal func add(_ metrics: Metrics, force: Bool = false, delay: Bool = false) {
        let operation = { [weak self] in
            var save = true
            let dao = self?.database.dao.metric
            
            if self?.isMetricRequiredToBeSaved == true {
                save = true
                self?.lastSavedForMetric = Date()
            } else {
                save = false
            }
            
            dao?.create(with: metrics, save: save)
            
            if force {
                self?.schedule()
            }
        }
        
        if delay {
            dispatchQueue.asyncAfter(deadline: .now() + 1, execute: operation)
        } else {
            dispatchQueue.async(execute: operation)
        }
        
        observation?(metrics)
    }
    
    internal func add(_ traces: [TraceModel], force: Bool = false, delay: Bool = false) {
        let operation = { [weak self] in
            var save = true
            let dao = self?.database.dao.trace
            
            if self?.isTraceRequiredToBeSaved == true {
                save = true
                self?.lastSavedForTrace = Date()
            } else {
                save = false
            }
            
            let attributes = Trace.shared.attributes
            
            func willAddResourceInAddTraceMethod() { }
            func didAddResourceInAddTraceMethod() { }
            
            willAddResourceInAddTraceMethod()
            
            let resource = self?.session.resource
            
            traces.forEach {
                $0.resource = resource
                $0.attributes = attributes
            }
            
            didAddResourceInAddTraceMethod()
            
            dao?.create(with: traces, save: save, synchronous: false)
            
            if force {
                self?.schedule()
            }
        }
        
        if delay {
            dispatchQueue.asyncAfter(deadline: .now() + 1, execute: operation)
        } else {
            dispatchQueue.async(execute: operation)
        }
    }
    
    // MARK: - Pending/Save
    
    @discardableResult
    private func savePendingManagedObjects() -> Bool {
        guard isTraceRequiredToBeSaved || isMetricRequiredToBeSaved else {
            return false
        }
        
        save()
        
        return true
    }
    
    private func save() {
        let date = Date()
        
        database.saveAll()
        
        lastSavedForTrace = date
        lastSavedForMetric = date
    }
    
    // MARK: - State
    
    func restart() {
        repeater.state = .resume
        
        savePendingManagedObjects()
        schedule()
    }
}

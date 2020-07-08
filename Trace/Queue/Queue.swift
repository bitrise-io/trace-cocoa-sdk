//
//  Queue.swift
//  Trace
//
//  Created by Shams Ahmed on 18/06/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
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
    
    private var lastSave: Date = Date()
    
    internal var observation: ((Metrics) -> Void)?
    
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
        database.dao.metric.allInBackground(limit: 300) { [weak self] dbModels in
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
                
                let names = Set(combined.map { $0.descriptor.name.rawValue })
                let attributes = Trace.shared.attributes
                let resource = self?.session.resource
                
                if resource == nil {
                    Logger.print(.internalError, "Resource missing from new metric model")
                }
                
                let model = Metrics(combined, resource: resource, attributes: attributes)
                
                Logger.print(.queue, "Scheduling \(combined.count) metrics from \(dbModels.count). Type: \(names.joined(separator: ", "))")
                
                self?.scheduler.schedule(model, {
                    switch $0 {
                    case .success: self?.database.dao.metric.delete(dbModels)
                    case .failure: Logger.print(.queue, "Failed to submit metric, will try again in 1 minute.")
                    }
                })
            } catch {
                Logger.print(.queue, "Failed to create Metric class from json: \(error)")
            }
        }
    }
    
    func scheduleTraces() {
        database.dao.trace.allInBackground(limit: 100) { [weak self] dbModels in
            guard !dbModels.isEmpty else { return }
            
            do {
                // DBTrace to Trace model
                let decoder = JSONDecoder()
                let traces = try dbModels.map { try decoder.decode(TraceModel.self, from: $0.json as Data) }
                let combined = Dictionary(grouping: traces, by: { $0.resource })
                    .map { _, values -> TraceModel in
                        let combined = values[0]
                        
                        for value in values where combined.traceId != value.traceId {
                            combined.spans.append(contentsOf: value.spans)
                        }
                        
                        return combined
                    }
                
                Logger.print(.queue, "Scheduling \(combined.count) traces")
                
                combined.forEach { trace in
                    self?.scheduler.schedule(trace, {
                        switch $0 {
                        case .success:
                            let ids = Set(trace.spans.map { $0.traceId })
                            let toBeDeleted = dbModels.filter { ids.contains($0.traceId) }
                            
                            self?.database.dao.trace.delete(toBeDeleted)
                        case .failure:
                            Logger.print(.queue, "Failed to submit trace, will try again in 1 minute.")
                        }
                    })
                }
            } catch {
                Logger.print(.queue, "Failed to create Trace class from json: \(error)")
            }
        }
    }
    
    // MARK: - Add
    
    internal func add(_ metrics: Metrics, force: Bool = false, delay: Bool = false) {
        let operation = { [weak self] in
            var save = true
            
            if let last = self?.lastSave {
                let calendar = Calendar.current
                let date = Date()
                let components = calendar.dateComponents([.second], from: last, to: date)
                
                if let second = components.second, second >= Queue.timeout {
                    save = true
                    self?.lastSave = Date()
                } else {
                    save = false
                }
            }
            
            self?.database.dao.metric.create(
                with: metrics,
                save: save
            )
            
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
            
            if let last = self?.lastSave {
                let calendar = Calendar.current
                let date = Date()
                let components = calendar.dateComponents([.second], from: last, to: date)
                
                if let second = components.second, second >= Queue.timeout {
                    save = true
                    self?.lastSave = Date()
                } else {
                    save = false
                }
            }
            
            let attributes = Trace.shared.attributes
            let resource = self?.session.resource
            
            if resource == nil {
                Logger.print(.internalError, "Resource missing from new trace model")
            }
            
            traces.forEach {
                $0.resource = resource
                $0.attributes = attributes
            }
            
            self?.database.dao.trace.create(with: traces, save: save, synchronous: false)
            
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
    
    // MARK: - State
    
    func restart() {
        repeater.state = .resume
        
        schedule()
    }
}

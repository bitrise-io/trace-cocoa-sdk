//
//  Tracer.swift
//  Trace
//
//  Created by Shams Ahmed on 16/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

/// Tracer class handles the management of each trace and it's session
final class Tracer {
    
    // MARK: - Property
    
    private let queue: Queue
    private let session: Session
    private let crash: CrashController
    private let dispatchQueue = DispatchQueueSynchronized(
        label: Constants.SDK.name.rawValue + ".Tracer",
        qos: .background
    )
    
    /// Should be private but required for testing
    private(set) var traces: [TraceModel] = []
    
    // MARK: - Init
    
    init(with queue: Queue, _ session: Session, _ crash: CrashController) {
        self.queue = queue
        self.session = session
        self.crash = crash
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Trace
    
    @discardableResult
    func add(_ trace: TraceModel) -> Bool {
        guard !traces.contains(trace) else {
            Logger.warning(.internalError, "Trying to add duplicate trace with traceId: \(trace.traceId)")
            
            return false
        }
        
        traces.append(trace)
        crash.userInfo[CrashController.Keys.traceId.rawValue] = trace.traceId
        
        Logger.debug(.traceModel, trace)
        
        return true
    }
    
    private func locateTrace(from startTimes: [TraceModel.Span.Timestamp]) -> TraceModel? {
        var trace: TraceModel?
        
        if traces.count == 1 {
            trace = traces.first
        } else if Thread.isMainThread {
            trace = UIApplication.shared.currentViewController()?.trace
        } else if DispatchQueue.isMainQueue {
            trace = UIApplication.shared.currentViewController()?.trace
        } else {
             return nil // try using inside a async main thread instead!
        }
        
        // Check if it's nil while in the main thread then fallback to the last trace on record
        if trace == nil, let lastKnownTrace = traces.last {
            Logger.debug(.traceModel, "Using last trace as current active view controller was not found")
            
            trace = lastKnownTrace
        }
        
        // validation
        if let trace = trace {
            let traceStartTime = trace.root.start
            let isGreaterThanStartTime = startTimes.contains { $0 >= traceStartTime }
            
            if !isGreaterThanStartTime {
                // TODO: Too much noise
                // Logger.warning(.traceModel, "Warning new child span started before current Trace")
            }
        }
        
        return trace
    }
    
    private func update(trace: TraceModel, with spans: [TraceModel.Span]) {
        dispatchQueue.sync { [trace] in
            let traceId = trace.traceId
            let parentSpanId = trace.root.spanId // expensive
            
            spans.forEach {
                $0.traceId = traceId
                
                if $0.parentSpanId == nil { // exclude root span i.e parentSpanId is nil
                    $0.parentSpanId = parentSpanId
                } else {
                    Logger.warning(.traceModel, "Property `parentSpanId` not set as it may be a root span")
                }
            }
            
            trace.spans.append(contentsOf: spans)
        }
    }
    
    // MARK: - Child
    
    func addChild(_ spans: [TraceModel.Span]) {
        #if DEBUG || Debug || debug
        // TODO: only for private beta testing. remove before GA
        spans.forEach { $0.validate() }
        #endif
        
        let startTimes = spans.map { $0.start }
        
        guard let trace = locateTrace(from: startTimes) else { // regardless of the thread
            DispatchQueue.main.async(qos: .utility) { [weak self] in
                if let trace = self?.locateTrace(from: startTimes) { // second try on main thread
                    self?.update(trace: trace, with: spans)
                } else {
                    Logger.debug(.internalError, "Failed to find active trace in async main thread")
                }
            }
                        
            return
        }
        
        update(trace: trace, with: spans)
    }
    
    // MARK: - Finish
    
    @discardableResult
    func finish(_ trace: TraceModel, withCustomTimestamp: Time.Timestamp? = nil) -> Bool {
        guard traces.contains(trace) else {
            Logger.warning(.traceModel, "Failed to find trace model: \(trace.traceId)")
            
            return false
        }
        
        #if DEBUG || Debug || debug
        // getting hold of root is expensive
        let root: TraceModel.Span! = trace.root
        
        Logger.debug(.traceModel, "Tracing finished for trace id: \(trace.traceId) name: \(root.name.value)")
        #endif
        
        dispatchQueue.sync {
            if let customTimestamp = withCustomTimestamp {
                trace.finish(with: customTimestamp)
            } else {
                trace.finish()
            }
            
            sendToQueue()
        }
        
        return true
    }
    
    func finishAll() {
        Logger.debug(.traceModel, "Tracing finished for \(traces.count) traces")

        dispatchQueue.sync {
            traces.forEach { $0.finish() }

            sendToQueue()
        }
    }
    
    // MARK: - Queueing
    
    private func sendToQueue() {
        var toBeSavedTraces: [TraceModel] = []

        traces.removeAll { trace in
            // don't remove active traces
            guard trace.isComplete else { return false }
            
            let root: TraceModel.Span = trace.root
            
            // avoid appending invalid traces i.e negative timestamp
            if root.validate() {
                toBeSavedTraces.append(trace)
            } else {
                Logger.warning(.internalError, "Invalid Trace: \(trace)")
            }
            
            return true
        }
        
        queue.add(toBeSavedTraces)
    }
}

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
    private let dispatchQueue = DispatchQueue(
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
            Logger.print(.internalError, "Trying to add duplicate trace with traceId: \(trace.traceId)")
            
            return false
        }
        
        traces.append(trace)
        crash.userInfo["Trace Id"] = trace.traceId
        
        Logger.print(.traceModel, trace)
        
        return true
    }
    
    // MARK: - Child
    
    func addChild(_ spans: [TraceModel.Span]) {
        #if DEBUG || Debug || debug
        // TODO: only for private beta testing. remove before GA
        spans.forEach {
            if !$0.validate() {
                Logger.print(.internalError, "Child span has invalid timestamp")
            }
        }
        #endif
        
        guard let trace: TraceModel = {
            if Thread.isMainThread {
                if let model = UIApplication.shared.currentViewController()?.trace {
                    return model
                }
            } else if let model = DispatchQueue.main.sync(execute: { UIApplication.shared.currentViewController()?.trace }) {
                return model
            }
                     
            if let lastKnownTrace = traces.last {
                Logger.print(.traceModel, "Using last trace as current active view controller was not found")
                
                return lastKnownTrace
            }
            
            Logger.print(.traceModel, "No active trace found")
            
            return nil
        }() else {
            Logger.print(.internalError, "Failed to find active trace")
                        
            return
        }
        
        dispatchQueue.sync { [trace] in
            // validation
            if trace.isComplete {
                Logger.print(.traceModel, "Trace is appending child while marked as complete")
                // V2: find the last incomplete trace model or return error
            }
            
            let traceId = trace.traceId
            let parentSpanId = trace.root.spanId // expensive
            
            spans.forEach {
                $0.traceId = traceId
                
                if $0.parentSpanId == nil { // exclude root span i.e parentSpanId is nil
                    $0.parentSpanId = parentSpanId
                } else {
                    Logger.print(.traceModel, "Property parentSpanId not set as it may be a root span")
                }
            }
            
            trace.spans.append(contentsOf: spans)
        }
    }
    
    // MARK: - Finish
    
    @discardableResult
    func finish(_ trace: TraceModel) -> Bool {
        guard traces.contains(trace) else {
            Logger.print(.traceModel, "Failed to find trace model: \(trace.traceId)")
            
            return false
        }
        
        Logger.print(.traceModel, "Tracing finished for trace id: \(trace.traceId) name: \(trace.root.name.value)")

        dispatchQueue.sync {
            trace.finish()

            sendToQueue()
        }
        
        return true
    }
    
    func finishAll() {
        Logger.print(.traceModel, "Tracing finished for \(traces.count) traces")

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
                Logger.print(.internalError, "Disregarding invalid trace \(trace)")
                // also removes from trace list since it's complete
            }
            
            return true
        }
        
        queue.add(toBeSavedTraces)
    }
}

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
        guard let trace: TraceModel = {
            if Thread.isMainThread {
                if let model = UIApplication.shared.currentViewController()?.trace {
                    return model
                }
            } else if let model = DispatchQueue.main.sync(execute: { UIApplication.shared.currentViewController()?.trace }) {
                return model
            }

            Logger.print(.traceModel, "Using last trace as current active view controller was not found")
                            
            return traces.last
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
                
                if $0.parentSpanId != nil { // exclude root span i.e parentSpanId is nil
                    $0.parentSpanId = parentSpanId
                }
            }
            
            trace.spans.append(contentsOf: spans)
        }
    }
    
    // MARK: - Finish
    
    @discardableResult
    func finish(_ trace: TraceModel) -> Bool {
        guard traces.contains(trace) else { return false }
        
        Logger.print(.traceModel, "Tracing finished for trace id: \(trace.traceId) name: \(trace.root.name.value)")

        dispatchQueue.sync {
            trace.finish()

            save()
        }
        
        return true
    }
    
    func finishAll() {
        Logger.print(.traceModel, "Tracing finished for \(traces.count) traces")

        dispatchQueue.sync {
            traces.forEach { $0.finish() }

            save()
        }
    }
    
    // MARK: - Save
    
    private func save() {
        var toBeSavedTraces: [TraceModel] = []

        traces.removeAll { trace in
            // don't remove active traces
            guard trace.isComplete else { return false }

            let root: TraceModel.Span = trace.root
            let start = root.start
            let end = root.end
            let validator = NanosecondValidator(start: start, end: end)
            
            // avoid apending invalid traces i.e negative timestamp
            if trace.root.validate() {
                if validator.isGreaterThanOrEqual(5000) {
                    toBeSavedTraces.append(trace)
                } else {
                    Logger.print(.internalError, "Disregarding trace as it's less than 5000 nanosecond \(trace)")
                    // also removes from trace list since it's does pass validation
                }
            } else {
                Logger.print(.internalError, "Disregarding invalid trace \(trace)")
                // also removes from trace list since it's complete
            }
            
            return true
        }

        queue.add(toBeSavedTraces)
    }
}

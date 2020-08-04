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
    private let dispatchQueue = DispatchQueue(
        label: Constants.SDK.name.rawValue + ".Tracer",
        qos: .background
    )
    
    /// Should be private but required for testing
    private(set) var traces: [TraceModel] = []
    
    // MARK: - Init
    
    init(with queue: Queue, _ session: Session) {
        self.queue = queue
        self.session = session
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Trace
    
    func add(_ trace: TraceModel) {
        traces.append(trace)
        
        Logger.print(.traceModel, trace)
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
    
    func finish(_ trace: TraceModel) {
        Logger.print(.traceModel, "Tracing finished for \(trace.traceId)")

        dispatchQueue.sync {
            trace.finish()

            save()
        }
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
            guard trace.isComplete else { return false }

            toBeSavedTraces.append(trace)

            return true
        }

        queue.add(toBeSavedTraces)
    }
}

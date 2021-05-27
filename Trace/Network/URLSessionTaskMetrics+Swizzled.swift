//
//  URLSessionTaskMetrics+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 01/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import ObjectiveC

extension URLSessionTaskMetrics: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        // private method.. easy way to avoid Apple discovering in their automatic string analysis tool
        let part1 = "_init"
        let part2 = "With"
        let part3 = "Task:"
        let initWithTask = Selectors(
            original: Selector((part1 + part2 + part3)), // _initWithTask:
            alternative: #selector(URLSessionTaskMetrics.bitrise_initWithTask(_:))
        )
        let result = self.swizzleInstanceMethod(initWithTask)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return result
    }
    
    // MARK: - URLSessionTaskMetrics
   
    @objc
    private func bitrise_initWithTask(_ task: URLSessionTask) -> URLSessionTaskMetrics {
        let metrics = self.bitrise_initWithTask(task)

        process(metrics)
        
        return metrics
    }
    
    // MARK: - Process
    
    private func process(_ metrics: URLSessionTaskMetrics) {
        let api = Constants.API.absoluteString
        let isBitriseMetric = metrics.transactionMetrics.contains {
            return $0.request.url?.absoluteString.contains(api) == true
        }
        
        guard !isBitriseMetric else { return }
        
        let formatter = TaskMetricsFormatter(metrics)
        let spans = formatter.spans
        
        let shared = Trace.shared
        shared.tracer.addChild(spans)
        shared.queue.add(formatter.metrics)
        
        // some odd reason, this object get freed up and crashes the app, so i made sure it stay in memory a little longer the holding on to it after using it above to try stop it crashing.
        _ = spans
    }
}

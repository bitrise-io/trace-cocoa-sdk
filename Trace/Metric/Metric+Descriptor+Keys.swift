//
//  Metric+Descriptor+Keys.swift
//  Trace
//
//  Created by Shams Ahmed on 18/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Metric
extension Metric.Descriptor {
    
    // MARK: - Name
    
    enum Name: String, Codable {
        
        // MARK: - Metric
        
        case appRequestSizeBytes = "app.request.size.bytes"
        case appResponseSizeBytes = "app.response.size.bytes"
        case appErrorTotal = "app.error.total"
        case viewFrameRate = "view.frame.rate"
        case appCrashTotal = "app.crash.total"
        case appStartupLatencyMS = "app.startup.latency.ms"
        case systemCpuPct = "system.cpu.pct"
        case processCpuPct = "process.cpu.pct"
        case appMemoryBytes = "app.memory.bytes"
        
        // MARK: - Post MVP (Needs reviewing)
        
        case subviewRenderLatencyMS = "subview.render.latency.ms" // Post MVP - Disabled
        case appSessionMilliseconds = "app.session.milliseconds" // Post MVP
        case appRequestTask = "app.request.task" // Post MVP
        case httpSessionConfiguration = "http.session.configuration" // Post MVP
        case appPrerequestTotal = "app.prerequest.total" // Post MVP
    
        // MARK: - Collatable
        
        /// Is the metric collatable where one metric can contain all the other data
        var isCollatable: Bool {
            switch self {
            case .appErrorTotal,
                 .appCrashTotal,
                 .appStartupLatencyMS,
                 .systemCpuPct,
                 .appMemoryBytes,
                 .processCpuPct,
                 .viewFrameRate,
                 .httpSessionConfiguration,
                 .subviewRenderLatencyMS: return true
            case .appRequestSizeBytes,
                 .appResponseSizeBytes,
                 .appSessionMilliseconds,
                 .appRequestTask,
                 .appPrerequestTotal: return false
            }
        }
        
        // MARK: - Countable
        
        /// Increases count instead of creating a new metric since all we care about is the number of time this happen in one session
        var isCountable: Bool {
            switch self {
            case .appErrorTotal,
                 .appCrashTotal: return true
            case .appRequestSizeBytes,
                 .appResponseSizeBytes,
                 .appStartupLatencyMS,
                 .systemCpuPct,
                 .appMemoryBytes,
                 .processCpuPct,
                 .viewFrameRate,
                 .appSessionMilliseconds,
                 .appRequestTask,
                 .appPrerequestTotal,
                 .httpSessionConfiguration,
                 .subviewRenderLatencyMS: return false
            }
        }
    }
}

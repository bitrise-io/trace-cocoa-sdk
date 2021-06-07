//
//  FPSFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 27/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

internal struct FPSFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case name = "view"
        case fps
        case timestamp
    }
    
    // MARK: - Property
    
    private let result: FPS.Result
    
    // MARK: - Init
    
    internal init(_ result: FPS.Result) {
        self.result = result
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        var timestamp = ""
        
        if let json = result.timestamp.jsonString() {
            timestamp = json
        }
        
        var details = OrderedDictionary<String, String>()
        details[Keys.name.rawValue] = result.viewController
        details[Keys.fps.rawValue] = String(result.fps)
        details[Keys.timestamp.rawValue] = timestamp
        
        return details
    }
}

extension FPSFormatter: Metricable {
    
    // MARK: - Metric
    
    internal var metrics: Metrics {
        guard result.fps >= 1.0 else { return Metrics([Metric]()) }
        
        let timeseries = Metric.Timeseries(
            .value(result.viewController),
            points: [.point(seconds: result.timestamp.seconds, nanos: result.timestamp.nanos, value: result.fps)]
        )
        let descriptor = Metric.Descriptor(
            name: .viewFrameRate,
            description: "Application frame rate",
            unit: .one,
            type: .int64,
            keys: [.init(Keys.name.rawValue)]
        )
        let metric = Metric(descriptor: descriptor, timeseries: [timeseries])
        
        return Metrics([metric])
    }
}

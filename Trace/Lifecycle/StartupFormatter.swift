//
//  StartupFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 28/06/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation

internal struct StartupFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case name = "app.start.state"
        case time
        case status
    }
    
    internal enum Status: String {
        case cold
        case warm
    }
    
    // MARK: - Property
    
    private let time: Double
    private let status: Status
    private let timestamp = Time.timestamp
    
    // MARK: - Init
    
    internal init(_ time: Double, status: Status) {
        self.time = time
        self.status = status
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        return [
            Keys.time.rawValue: String(time.rounded(to: 2)),
            Keys.status.rawValue: status.rawValue
        ]
    }
}

extension StartupFormatter: Metricable {
    
    // MARK: - Metric
    
    internal var metrics: Metrics {
        let timeseries = Metric.Timeseries(
            .value(status.rawValue),
            points: [.point(seconds: timestamp.seconds, nanos: timestamp.nanos, value: time.rounded(to: 2))]
        )
        let descriptor = Metric.Descriptor(
            name: .appStartupLatencyMS,
            description: "App startup latency in milliseconds",
            unit: .ms,
            type: .int64,
            keys: [.init(Keys.name.rawValue)]
        )
        let metric = Metric(descriptor: descriptor, timeseries: [timeseries])
        
        return Metrics([metric])
    }
}

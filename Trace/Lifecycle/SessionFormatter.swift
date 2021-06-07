//
//  SessionFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 06/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Disabled
internal struct SessionFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case reason
        case duration
    }
    
    enum Reason: String {
        case background
        case terminated
    }
    
    // MARK: - Property
    
    private let reason: Reason
    private let time: Double
    private let timestamp = Time.timestamp
    
    // MARK: - Init
    
    internal init(_ reason: Reason, time: Double) {
        self.reason = reason
        self.time = time
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        Logger.debug(.application, "Current session duration: \(time.rounded(to: 2))")
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        return [
            Keys.reason.rawValue: reason.rawValue,
            Keys.duration.rawValue: String(time.rounded(to: 2))
        ]
    }
}

extension SessionFormatter: Metricable {
    
    // MARK: - Metric
    
    internal var metrics: Metrics {
        let result = time.rounded(to: 2)
        let timeseries = [
            Metric.Timeseries(
                [.value(reason.rawValue), .value(String(result))],
                points: [.point(seconds: timestamp.seconds, nanos: timestamp.nanos, value: result)]
            )
        ]
        let descriptor = Metric.Descriptor(
            name: .appSessionMilliseconds,
            description: "App session in milliseconds",
            unit: .ms,
            type: .int64,
            keys: [.init(Keys.reason.rawValue), .init(Keys.duration.rawValue)]
        )
        let metric = Metric(descriptor: descriptor, timeseries: timeseries)
        
        return Metrics([metric])
    }
}

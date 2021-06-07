//
//  ErrorFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 15/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal struct ErrorFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case name
        case reason
        case metadata
        case errorCode = "error_code"
    }
    
    // MARK: - Property
    
    private let domain: String
    private let code: Int
    private let userinfo: [String: Any]?
    private let metadata: [String: String]?
    
    private let timestamp = Time.timestamp
    
    // MARK: - Init
    
    internal init(domain: String, code: Int, userinfo: [String: Any]?, metadata: [String: String]?=nil) {
        self.domain = domain
        self.code = code
        self.userinfo = userinfo
        self.metadata = metadata
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        var detail: OrderedDictionary<String, String> = [
            Keys.name.rawValue: domain,
            Keys.errorCode.rawValue: String(code),
            Keys.reason.rawValue: reason
        ]
        
        if let metadata = metadata.jsonString() {
            detail[Keys.metadata.rawValue] = metadata
        }
        
        return detail
    }
    
    private var reason: String {
        guard let reason = userinfo?.values.first as? String else { return "" }
        
        return reason
    }
}

extension ErrorFormatter: Metricable {
    
    // MARK: - Metric
    
    internal var metrics: Metrics {
        let keys: [Metric.Descriptor.Key] = [
            .init(Keys.errorCode.rawValue)
        ]
        let timeseries = Metric.Timeseries(
            [.value(String(code))],
            points: [.point(seconds: timestamp.seconds, nanos: timestamp.nanos, value: 1)]
        )
        let descriptor = Metric.Descriptor(
            name: .appErrorTotal,
            description: "Total number of application errors",
            unit: .one,
            type: .cumulativeInt64,
            keys: keys
        )
        let metric = Metric(
            descriptor: descriptor,
            timeseries: timeseries
        )
        
        return Metrics([metric])
    }
}

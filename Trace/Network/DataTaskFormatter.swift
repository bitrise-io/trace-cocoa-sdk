//
//  DataTaskFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 11/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Disabled
internal struct DataTaskFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    internal enum Keys: String {
        case countOfBytesReceived = "http.task.count.of.bytes.received"
        case countOfBytesSent = "http.task.count.of.bytes.sent"
        case response = "http.task.response"
        case error = "http.task.error"
    }
    
    // MARK: - Property
    
    private let task: URLSessionTask
    let timestamp = Time.timestamp
    
    // MARK: - Init
    
    internal init(_ task: URLSessionTask) {
        self.task = task
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        return [
            Keys.countOfBytesReceived.rawValue: String(task.countOfBytesReceived),
            Keys.countOfBytesSent.rawValue: String(task.countOfBytesSent),
            Keys.error.rawValue: String(task.error?.localizedDescription ?? "")
        ]
    }
}

extension DataTaskFormatter: Metricable {
    
    // MARK: - Metrics
    
    var metrics: Metrics {
        var keys = [Metric.Descriptor.Key]()
        var values = [Metric.Timeseries.Value]()
        
        let detail = details
        detail.forEach {
            guard !$0.value.isObjectEmpty else { return }
            
            keys.append(Metric.Descriptor.Key($0.key))
            values.append(.value($0.value))
        }
        
        let timeseries = Metric.Timeseries(
            values,
            points: [.point(seconds: timestamp.seconds, nanos: timestamp.nanos, value: 1)]
        )
        let descriptor = Metric.Descriptor(
            name: .appRequestTask,
            description: "HTTP Request Task",
            unit: .string,
            type: .int64,
            keys: keys
        )
        let metric = Metric(descriptor: descriptor, timeseries: [timeseries])
        
        return Metrics([metric])
    }
}

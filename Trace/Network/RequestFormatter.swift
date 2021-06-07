//
//  RequestFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 10/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Disabled
internal struct RequestFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case url = "http.url"
        case method = "http.method"
        case bodySize = "http.body.size"
    }
    
    // MARK: - Property
    
    private let request: URLRequest
    let timestamp = Time.timestamp
    
    // MARK: - Init
    
    internal init(_ request: URLRequest) {
        self.request = request

        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Formatter
    
    internal var details: OrderedDictionary<String, String> {
        let url = request.url
        let urlStructure = URLStructure(url: url)
        let size = String(request.httpBody?.count ?? 0)
        var method = "Unknown"
        var formattedURL = "Unknown"
        
        if let value = request.httpMethod {
            method = value
        }
        
        if let value = urlStructure.format() {
            formattedURL = value
        }
        
        return [
            Keys.url.rawValue: formattedURL,
            Keys.method.rawValue: method,
            Keys.bodySize.rawValue: String(size)
        ]
    }
}

extension RequestFormatter: Metricable {
    
    // MARK: - Metric
    
    var metrics: Metrics {
        var keys = [Metric.Descriptor.Key]()
        var values = [Metric.Timeseries.Value]()
        
        let detail = details
        detail.forEach {
            guard !$0.value.isObjectEmpty else { return }
            
            keys.append(Metric.Descriptor.Key($0.key))
            values.append(.value($0.value))
        }
        
        var bodySize: Double = 0
        
        if let size = detail[Keys.bodySize.rawValue], let double = Double(size) {
            bodySize = double
        }
        
        let timeseries = Metric.Timeseries(
            values,
            points: [.point(seconds: timestamp.seconds, nanos: timestamp.nanos, value: bodySize)]
        )
        let descriptor = Metric.Descriptor(
            name: .appPrerequestTotal,
            description: "Network request size in bytes",
            unit: .bytes,
            type: .int64,
            keys: keys
        )
        let metric = Metric(descriptor: descriptor, timeseries: [timeseries])
        
        return Metrics([metric])
    }
}

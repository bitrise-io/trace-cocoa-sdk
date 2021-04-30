//
//  Metric.swift
//  Trace
//
//  Created by Shams Ahmed on 13/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal protocol Metricable {
    
    var metrics: Metrics { get }
    
    // MARK: - Helper
    
    func metric(for name: Metric.Descriptor.Name, description: String, unit: Metric.Descriptor.Unit, type: Metric.Descriptor.`Type`, detail: OrderedDictionary<String, String>, points: [Metric.Timeseries.Point]) -> Metric
}

extension Metricable {
    
    // MARK: - Helper
    
    func metric(for name: Metric.Descriptor.Name, description: String, unit: Metric.Descriptor.Unit, type: Metric.Descriptor.`Type`, detail: OrderedDictionary<String, String>, points: [Metric.Timeseries.Point]) -> Metric {
        var keys = [Metric.Descriptor.Key]()
        var values = [Metric.Timeseries.Value]()
        
        detail.forEach {
            guard !$0.value.isObjectEmpty else { return }
            
            keys.append(Metric.Descriptor.Key($0.key))
            values.append(.value($0.value))
        }
        
        let timeseries = Metric.Timeseries(
            values,
            points: points
        )
        let descriptor = Metric.Descriptor(
            name: name,
            description: description,
            unit: unit,
            type: type,
            keys: keys
        )
        let metric = Metric(descriptor: descriptor, timeseries: [timeseries])
        
        return metric
    }
}

/// Metric Descriptor
internal struct Metric: Codable {
    
    // MARK: - Enum
    
    private enum CodingKeys: String, CodingKey {
        case descriptor = "metric_descriptor"
        case timeseries
    }
    
    // MARK: - Property
    
    internal let descriptor: Descriptor
    internal let timeseries: [Timeseries]
    
    // MARK: - Init
    
    internal init(descriptor: Descriptor, timeseries: Timeseries) {
        self.descriptor = descriptor
        self.timeseries = [timeseries]
        
        setup()
    }
    
    internal init(descriptor: Descriptor, timeseries: [Timeseries]) {
        self.descriptor = descriptor
        self.timeseries = timeseries
        
        setup()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        descriptor = try container.decode(Descriptor.self, forKey: .descriptor)
        timeseries = try container.decode([Timeseries].self, forKey: .timeseries)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        validate()
    }
    
    // MARK: - Validate
    
    @discardableResult
    private func validate() -> Bool {
        let count = descriptor.keys.count
        var result = true
        
        // validate
        for series in timeseries where series.values.count != count {
            let message = "Metric keys:\(count), values:\(series.values.count) mismatch for \(descriptor.name)"
            
            Logger.warning(.internalError, message)
            
            result = false
        }
        
        return result
    }
    
    // MARK: - Encode
    
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(timeseries, forKey: .timeseries)
        try container.encode(descriptor, forKey: .descriptor)
    }
}

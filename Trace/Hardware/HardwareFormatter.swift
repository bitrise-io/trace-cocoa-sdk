//
//  HardwareFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 11/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Formatter to get hold of all hardware metrics
internal struct HardwareFormatter: JSONEncodable {
    
    // MARK: - Property
    
    private let cpu: CPU
    private let memory: Memory
    private let connectivity: Connectivity
    
    private let timestamp = Time.timestamp
    
    // MARK: - Init
    
    internal init(cpu: CPU, memory: Memory, connectivity: Connectivity) {
        self.cpu = cpu
        self.memory = memory
        self.connectivity = connectivity
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        var details = detailsForSystemCPU
        details.merge(detailsForApplicationCPU)
        details.merge(detailsForApplicationMemory)
        
        return OrderedDictionary<String, String>(uniqueKeysWithValues: details)
    }
    
    private var detailsForSystemCPU: OrderedDictionary<String, String> {
        var timestamp = ""
        
        if let usage = cpu.systemUsage.timestamp.jsonString() {
            timestamp = usage
        }
        
        return [
            "system": String(cpu.systemUsage.system),
            "user": String(cpu.systemUsage.user),
            "idle": String(cpu.systemUsage.idle),
            "nice": String(cpu.systemUsage.nice),
            "timestamp": timestamp
        ]
    }
    
    private var detailsForApplicationCPU: OrderedDictionary<String, String> {
        var timestamp = ""
        
        if let usage = cpu.applicationUsage.timestamp.jsonString() {
            timestamp = usage
        }
        
        var model = OrderedDictionary<String, String>()
        model["overall"] = String(cpu.applicationUsage.overall)
        model["timestamp"] = timestamp
        
        cpu.perThreadUsage.forEach { model[$0.name] = String($0.usage) }
        
        return model
    }
    
    private var detailsForApplicationMemory: OrderedDictionary<String, String> {
        var timestamp = ""
        
        if let usage = memory.applicationUsage.timestamp.jsonString() {
            timestamp = usage
        }
        
        return [
            "res": String(memory.applicationUsage.used),
            "timestamp": timestamp
        ]
    }
}

extension HardwareFormatter: Metricable {
    
    // MARK: - Metric
    
    internal var metrics: Metrics {
        return Metrics([systemMetric, applicationMetric, applicationMemoryUsage])
    }
    
    private var applicationMemoryUsage: Metric {
        var keys = [Metric.Descriptor.Key]()
        var timeseries = [Metric.Timeseries]()
        let value = memory.applicationUsage
            
        keys.append(.init("memory.state"))
                
        timeseries.append(Metric.Timeseries(
            .value("res"),
            points: [.point(seconds: value.timestamp.seconds, nanos: value.timestamp.nanos, value: value.used.rounded(to: 1))])
        )
        
        let descriptor = Metric.Descriptor(
            name: .appMemoryBytes,
            description: "App Memory Usage",
            unit: .bytes,
            type: .int64,
            keys: keys
        )
        let metric = Metric(descriptor: descriptor, timeseries: timeseries)
        
        return metric
    }
    
    private var applicationMetric: Metric {
        let value = cpu.applicationUsage
        let timeseries = Metric.Timeseries(
            [],
            points: [.point(seconds: value.timestamp.seconds, nanos: value.timestamp.nanos, value: value.overall.rounded(to: 2))]
        )
        
        let descriptor = Metric.Descriptor(
            name: .processCpuPct,
            description: "Application CPU Usage",
            unit: .percent,
            type: .double,
            keys: []
        )
        let metric = Metric(descriptor: descriptor, timeseries: timeseries)
        
        return metric
    }
    
    private var systemMetric: Metric {
        var keys = [Metric.Descriptor.Key]()
        var timeseries = [Metric.Timeseries]()
        let value = cpu.systemUsage
        
        keys.append(.init("cpu.state"))
        timeseries.append(Metric.Timeseries(
            .value("system"),
            points: [.point(seconds: value.timestamp.seconds, nanos: value.timestamp.nanos, value: value.system.rounded(to: 1))])
        )
        timeseries.append(Metric.Timeseries(
            .value("user"),
            points: [.point(seconds: value.timestamp.seconds, nanos: value.timestamp.nanos, value: value.user.rounded(to: 1))])
        )
        timeseries.append(Metric.Timeseries(
            .value("idle"),
            points: [.point(seconds: value.timestamp.seconds, nanos: value.timestamp.nanos, value: value.idle.rounded(to: 1))])
        )
        timeseries.append(Metric.Timeseries(
            .value("nice"),
            points: [.point(seconds: value.timestamp.seconds, nanos: value.timestamp.nanos, value: value.nice.rounded(to: 1))])
        )
        
        let descriptor = Metric.Descriptor(
            name: .systemCpuPct,
            description: "System CPU Usage",
            unit: .percent,
            type: .double,
            keys: keys
        )
        let metric = Metric(descriptor: descriptor, timeseries: timeseries)
        
        return metric
    }
}

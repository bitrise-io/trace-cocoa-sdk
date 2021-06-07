//
//  SessionConfigurationFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 13/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Disabled
internal struct SessionConfigurationFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        enum Cache: String {
            case currentDiskUsage = "http.session.urlCache.current.disk.usage"
            case diskCapacity = "http.session.urlCache.disk.capacity"
            case currentMemoryUsage = "http.session.urlCache.current.memory.usage"
            case memoryCapacity = "http.session.urlCache.memory.capacity"
        }
        
        case identifier = "http.session.identifier"
        case timeoutIntervalForRequest = "http.session.timeout.interval.for.request"
        case timeoutIntervalForResource = "http.session.timeout.interval.for.resource"
        case httpShouldUsePipelining = "http.session.should.use.pipelining"
        case httpShouldSetCookies = "http.session.should.set.cookies"
        case httpMaximumConnectionsPerHost = "http.session.maximum.connections.per.host"
        case sessionSendsLaunchEvents = "http.session.sends.launch.events"
        case isDiscretionary = "http.session.isDiscretionary"
        case requestCachePolicy = "http.session.request.cache.policy"
        case waitsForConnectivity = "http.session.waits.for.connectivity"
    }
    
    // MARK: - Property
    
    private let configuration: URLSessionConfiguration
    let timestamp = Time.timestamp
    
    // MARK: - Init
    
    internal init(_ configuration: URLSessionConfiguration) {
        self.configuration = configuration
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    var details: OrderedDictionary<String, String> {
        var details = OrderedDictionary<String, String>()
        details[Keys.identifier.rawValue] = configuration.identifier ?? "Unknown"
        details[Keys.timeoutIntervalForRequest.rawValue] = String(configuration.timeoutIntervalForRequest)
        details[Keys.timeoutIntervalForResource.rawValue] = String(configuration.timeoutIntervalForResource)
        
        details[Keys.sessionSendsLaunchEvents.rawValue] = String(configuration.sessionSendsLaunchEvents)
        
        if let cache = configuration.urlCache {
            details[Keys.Cache.currentDiskUsage.rawValue] = String(cache.currentDiskUsage)
            details[Keys.Cache.diskCapacity.rawValue] = String(cache.diskCapacity)
            details[Keys.Cache.currentMemoryUsage.rawValue] = String(cache.currentMemoryUsage)
            details[Keys.Cache.memoryCapacity.rawValue] = String(cache.memoryCapacity)
        }
        
        return details
    }
}

extension SessionConfigurationFormatter: Metricable {
    
    // MARK: - Metric
    
    internal var metrics: Metrics {
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
            name: .httpSessionConfiguration,
            description: "HTTP session configuration details",
            unit: .string,
            type: .int64,
            keys: keys
        )
        let metric = Metric(descriptor: descriptor, timeseries: [timeseries])
        
        return Metrics([metric])
    }
}

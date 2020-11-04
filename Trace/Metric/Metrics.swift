//
//  Metrics.swift
//  Trace
//
//  Created by Shams Ahmed on 13/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Metrics model to send to network
internal struct Metrics: Codable {
    
    // MARK: - Enum
    
    private enum CodingKeys: CodingKey {
        case metrics
        case resource
        case attributes
    }
    
    // MARK: - Property
    
    internal let metrics: [Metric]
    internal let resource: Resource?
    internal let attributes: [String: String]?
    
    // MARK: - Init
    
    internal init(_ metrics: [Metric], resource: Resource? = nil, attributes: [String: String]? = nil) {
        self.metrics = metrics
        self.resource = resource
        self.attributes = attributes
    }
    
    internal init(_ metricables: [Metricable], resource: Resource? = nil, attributes: [String: String]? = nil) {
        self.resource = resource
        self.attributes = attributes
        self.metrics = metricables
            .map { $0.metrics.metrics }
            .flatMap { $0 }
    }
    
    // MARK: - Encode
    
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(metrics, forKey: .metrics)
        
        if let resource = resource {
            try container.encode(resource, forKey: .resource)
        }
            
        if let attributes = attributes {
            try container.encode(attributes, forKey: .attributes)
        }
    }
}

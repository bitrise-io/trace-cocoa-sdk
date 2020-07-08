//
//  Metric+Timeseries.swift
//  Trace
//
//  Created by Shams Ahmed on 13/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension Metric {
    
    // MARK: - Timeseries
    
    struct Timeseries: Timeseriesble {
        
        // MARK: - Enum
        
        enum CodingKeys: String, CodingKey {
            case values = "label_values"
            case points
        }
        
        // MARK: - Property
        
        internal let values: [Value]
        internal var points: [Point]
        
        // MARK: - Init
        
        internal init(_ value: Value, points: [Point]) {
            self.values = [value]
            self.points = points
        }
        
        internal init(_ values: [Value], points: [Point]) {
            self.values = values
            self.points = points
        }
        
        internal init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            values = try container.decode([Value].self, forKey: .values)
            points = try container.decode([Point].self, forKey: .points)
        }
        
        // MARK: - Encode
        
        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(values, forKey: .values)
            try container.encode(points, forKey: .points)
        }
    }
}

//
//  Metric+Timeseries+Point.swift
//  Trace
//
//  Created by Shams Ahmed on 24/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension Metric.Timeseries {
    
    // MARK: - Point
    
    struct Point: Codable {
        
        // MARK: - Enum
        
        private enum CodingKeys: String, CodingKey {
            enum Timestamp: String, CodingKey {
                case seconds
                case nanos
            }
            
            case timestamp
            case value
        }
        
        enum Error: Swift.Error {
            case codingError
        }
        
        // MARK: - Property
        
        internal let seconds: Int
        internal let nanos: Int
        internal let value: Any
        
        // MARK: - Class
        
        internal static func point(seconds: Int, nanos: Int, value: Double) -> Point {
            return self.init(seconds: seconds, nanos: nanos, value: value)
        }
        
        internal static func point(seconds: Int, nanos: Int, value: Int) -> Point {
            return self.init(seconds: seconds, nanos: nanos, value: value)
        }
        
        // MARK: - Init
        
        private init(seconds: Int, nanos: Int, value: Double) {
            self.seconds = seconds
            self.nanos = nanos
            self.value = value
            
            setup()
        }
        
        private init(seconds: Int, nanos: Int, value: Int) {
            self.seconds = seconds
            self.nanos = nanos
            self.value = value
            
            setup()
        }
        
        internal init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let nestedContainer = try container.nestedContainer(
                keyedBy: CodingKeys.Timestamp.self,
                forKey: .timestamp
            )
            
            nanos = try nestedContainer.decode(Int.self, forKey: .nanos)
            seconds = try nestedContainer.decode(Int.self, forKey: .seconds)
            
            // Perks of Encodable, can't get the underline type
            // This assume we only work with the following type
            if let int = try? container.decode(Int.self, forKey: .value) {
                value = int
            } else if let double = try? container.decode(Double.self, forKey: .value) {
                value = double
            } else {
                throw Error.codingError
            }
            
            setup()
        }
        
        // MARK: - Setup
        
        private func setup() {
            #if DEBUG || Debug || debug
                // TODO: only for private beta testing. remove before GA
                if !TimestampValidator(toDate: Date()).isValid(seconds: seconds, nanos: nanos) {
                    Logger.debug(.internalError, "Metric timestamp \(seconds).\(nanos) is invalid")
                }
            #endif
        }
        
        // MARK: - Encode
        
        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            var nestedContainer = container.nestedContainer(
                keyedBy: CodingKeys.Timestamp.self,
                forKey: .timestamp
            )
            
            try nestedContainer.encode(seconds, forKey: .seconds)
            try nestedContainer.encode(nanos, forKey: .nanos)
            
            // Perks of Encodable, can't get the underline type
            // This assume we only work with the following type
            // Also String can't be used in Point class
            if let value = value as? Int {
                try container.encode(value, forKey: .value)
            } else if let value = value as? Double {
                try container.encode(value, forKey: .value)
            } else {
                throw Error.codingError
            }
        }
    }
}

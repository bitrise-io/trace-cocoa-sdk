//
//  Metric+Timeseries+Value.swift
//  Trace
//
//  Created by Shams Ahmed on 24/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension Metric.Timeseries {
    
    // MARK: - Value
    
    struct Value: Codable, Equatable {
        
        // MARK: - Enum
        
        private enum CodingKeys: String, CodingKey {
            case value
            case hasValue = "has_value"
        }
        
        enum Error: Swift.Error {
            case codingError
        }
        
        // MARK: - Compare
        
        static func == (lhs: Value, rhs: Value) -> Bool {
            switch (lhs.value, rhs.value) {
            case (let lhsValue as Int, let rhsValue as Int):
                return lhsValue == rhsValue && lhs.hasValue == rhs.hasValue
            case (let lhsValue as Double, let rhsValue as Double):
                return lhsValue == rhsValue && lhs.hasValue == rhs.hasValue
            case (let lhsValue as String, let rhsValue as String):
                return lhsValue == rhsValue && lhs.hasValue == rhs.hasValue
            default:
                return false
            }
        }
        
        // MARK: - Property
        
        private let value: Any
        
        internal let hasValue: Bool
        
        // MARK: - Class
        
        internal static func value(_ value: Any) -> Value {
            return self.init(value)
        }
        
        /// Value set to "" and has value false
        internal static var none: Value {
            return self.init("", hasValue: false)
        }
        
        // MARK: - Init
        
        /// Has value by default set to true
        init(_ value: Any, hasValue: Bool = true) {
            self.value = value
            self.hasValue = hasValue
        }
        
        internal init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Perks of Encodable, can't get the underline type
            // This assume we only work with the following type
            if let int = try? container.decode(Int.self, forKey: .value) {
                value = int
            } else if let double = try? container.decode(Double.self, forKey: .value) {
                value = double
            } else if let string = try? container.decode(String.self, forKey: .value) {
                value = string
            } else {
                throw Error.codingError
            }
            
            hasValue = try container.decode(Bool.self, forKey: .hasValue)
        }
        
        // MARK: - Encode
        
        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            // Perks of Encodable, can't get the underline type
            // This assume we only work with the following type
            if let value = value as? Int {
                try container.encode(value, forKey: .value)
            } else if let value = value as? Double {
                try container.encode(value, forKey: .value)
            } else if let value = value as? String {
                try container.encode(value, forKey: .value)
            } else {
                throw Error.codingError
            }
            
            try container.encode(hasValue, forKey: .hasValue)
        }
    }
}

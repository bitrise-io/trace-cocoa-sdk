//
//  Metric+Descriptor.swift
//  Trace
//
//  Created by Shams Ahmed on 13/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension Metric {
    
    // MARK: - Descriptor
    
    struct Descriptor: Codable {
        
        // MARK: - Key
        
        struct Key: Codable {
            
            // MARK: - Enum
            
            private enum CodingKeys: CodingKey {
                case key
                case description
            }
            
            // MARK: - Property
            
            internal let key: String
            internal let description: String
            
            // MARK: - Class
            
            internal static func key(_ key: String, description: String = "") -> Key {
                return self.init(key, description: description)
            }
            
            // MARK: - Init
            
            internal init(_ key: String, description: String = "") {
                self.key = key
                self.description = description
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
             
                description = try container.decode(String.self, forKey: .description)
                key = try container.decode(String.self, forKey: .key)
            }
            
            // MARK: - Encoder
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                try container.encode(description, forKey: .description)
                try container.encode(key, forKey: .key)
            }
        }
        
        // MARK: - Enum
        
        private enum CodingKeys: String, CodingKey {
            case name
            case description
            case unit
            case type
            case keys = "label_keys"
        }
        
        enum `Type`: Int, Codable {
            case int64 = 1
            case double = 2
            case distribution = 3
            case cumulativeInt64 = 4
            case cumulativeDouble = 5
            case cumulativeDistribution = 6
            case summary = 7
        }
        
        enum Unit: String, Codable {
            case one = "1"
            case ms
            case string
            case bytes
            case percent
        }
        
        // MARK: - Property
        
        internal let name: Name
        internal let description: String
        internal let unit: Unit
        internal let type: `Type`
        internal let keys: [Key]
        
        // MARK: - Init
        
        init(name: Name, description: String, unit: Unit, type: `Type`, keys: [Key]) {
            self.name = name
            self.description = description
            self.unit = unit
            self.type = type
            self.keys = keys
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            name = try container.decode(Name.self, forKey: .name)
            description = try container.decode(String.self, forKey: .description)
            unit = try container.decode(Unit.self, forKey: .unit)
            type = try container.decode(`Type`.self, forKey: .type)
            keys = try container.decode([Key].self, forKey: .keys)
        }
        
        // MARK: - Encode
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(name.rawValue, forKey: .name)
            try container.encode(description, forKey: .description)
            try container.encode(unit.rawValue, forKey: .unit)
            try container.encode(type.rawValue, forKey: .type)
            try container.encode(keys, forKey: .keys)
        }
    }
}

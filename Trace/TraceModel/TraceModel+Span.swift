//
//  TraceModel+Span.swift
//  Trace
//
//  Created by Shams Ahmed on 10/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal protocol Spanable {
    
    var spans: [TraceModel.Span] { get }
}

extension TraceModel {
    
    // MARK: - Span
    
    /// Span
    @objc(BRSpan)
    @objcMembers
    final public class Span: NSObject, NSCopying, Codable {
        
        // MARK: - Enum
        
        private enum CodingKeys: String, CodingKey {
            case traceId = "trace_id"
            case spanId = "span_id"
            case parentSpanId = "parent_span_id"
            case name
            case kind
            case start = "start_time"
            case end = "end_time"
            case attributes
        }
        
        enum Kind: Int, Codable {
            case unspecified = 0
            case server = 1
            case client = 2
        }
        
        // MARK: - Model
        
        struct Timestamp: Codable {
            
            // MARK: - Property
            
            let seconds: Int
            let nanos: Int
            
            // MARK: - Init
            
            init(seconds: Int, nanos: Int) {
                self.seconds = seconds
                self.nanos = nanos
                
                setup()
            }
            
            // MARK: - Setup
            
            private func setup() {
                #if Debug
                    // TODO: only for private beta testing. remove before GA
                    if !TimestampValidator(toDate: Date()).isValid(seconds: seconds, nanos: nanos) {
                        Logger.print(.internalError, "Timestamp \(seconds).\(nanos) is invalid")
                    }
                #endif
            }
        }
        
        struct Name: Codable {
            
            // MARK: - Enum
            
            private enum CodingKeys: String, CodingKey {
                case value
                case truncatedByteCount = "truncated_byte_count"
            }
            
            enum Error: Swift.Error {
                case codingError
            }
            
            // MARK: - Property
            
            var value: Any
            var truncatedByteCount: Int
            
            // MARK: - Init
            
            init(value: Any, truncatedByteCount: Int) {
                self.value = value
                self.truncatedByteCount = truncatedByteCount
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                if let int = try? container.decode(Int.self, forKey: .value) {
                    value = int
                } else if let double = try? container.decode(Double.self, forKey: .value) {
                    value = double
                } else if let string = try? container.decode(String.self, forKey: .value) {
                    value = string
                } else {
                    throw Error.codingError
                }
                
                truncatedByteCount = try container.decode(Int.self, forKey: .truncatedByteCount)
            }
            
            // MARK: - Encode
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                if let value = value as? Int {
                    try container.encode(value, forKey: .value)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: .value)
                } else if let value = value as? String {
                    try container.encode(value, forKey: .value)
                } else {
                    throw Error.codingError
                }
                
                try container.encode(truncatedByteCount, forKey: .truncatedByteCount)
            }
        }
        
        final class Attributes: Codable {
            
            // MARK: - Model
            
            enum Key: String {
                case value
            }
            
            struct Attribute {
                let name: String
                let value: Name
            }
            
            // MARK: - Enum
            
            private enum CodingKeys: String, CodingKey {
                case attributeMap = "attribute_map"
                case droppedAttributesCount = "dropped_attributes_count"
            }
            
            // MARK: - Property
            
            private(set) var attribute: [String: [String: Name]]
            let droppedAttributesCount: Int
            
            // MARK: - Init
            
            init() {
                self.attribute = [:]
                self.droppedAttributesCount = 0
            }
            
            init(attributes: [Attribute], droppedAttributesCount: Int = 0) {
                let attributeValues = attributes.reduce([String: [String: Name]]()) { result, attribute in
                    var result = result
                    result[attribute.name] = [Key.value.rawValue: attribute.value]
                    
                    return result
                }
                
                self.attribute = attributeValues
                self.droppedAttributesCount = droppedAttributesCount
            }
            
            private init(attribute: [String: [String: Name]], droppedAttributesCount: Int) {
                self.attribute = attribute
                self.droppedAttributesCount = droppedAttributesCount
            }
            
            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                attribute = try container.decode([String: [String: Name]].self, forKey: .attributeMap)
                droppedAttributesCount = try container.decode(Int.self, forKey: .droppedAttributesCount)
            }
            
            // MARK: - Append
            
            // pecker:ignore
            func append(_ model: Attribute) {
                attribute[model.name] = [Key.value.rawValue: model.value]
            }
            
            // MARK: - Encoder
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                try container.encode(attribute, forKey: .attributeMap)
                try container.encode(droppedAttributesCount, forKey: .droppedAttributesCount)
            }
        }
        
        // MARK: - Property
        
        var traceId: String?
        let spanId: String
        
        // Root
        var parentSpanId: String?
        
        var name: Name
        let kind: Kind
        
        let start: Timestamp
        var end: Timestamp?
        
        let attribute: Attributes
        
        // MARK: - Init
        
        init(name: Name, start: Timestamp, end: Timestamp? = nil, attribute: Attributes = Attributes()) {
            // set later
            self.traceId = nil
            self.parentSpanId = nil
            
            self.spanId = UUID.random(8)
            self.name = name
            self.kind = .client
            self.start = start
            self.end = end
            self.attribute = attribute
        }
        
        init(traceId: String?, spanId: String, name: Name, start: Timestamp, end: Timestamp? = nil, attribute: Attributes = Attributes(), kind: Kind = .client, parentSpanId: String?=nil) {
            self.traceId = traceId
            self.spanId = spanId
            self.parentSpanId = parentSpanId
            self.name = name
            self.kind = kind
            self.start = start
            self.end = end
            self.attribute = attribute
        }
        
        /// :nodoc:
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            traceId = try container.decode(String.self, forKey: .traceId).fromHex
            
            guard let span = try container.decode(String.self, forKey: .spanId).fromHex else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: decoder.codingPath,
                    debugDescription: "")
                )
            }
        
            spanId = span
            parentSpanId = try container.decode(String?.self, forKey: .parentSpanId)?.fromHex
            name = try container.decode(Name.self, forKey: .name)
            kind = try container.decode(Kind.self, forKey: .kind)
            start = try container.decode(Timestamp.self, forKey: .start)
            end = try container.decode(Timestamp?.self, forKey: .end)
            attribute = try container.decode(Attributes.self, forKey: .attributes)
        }
        
        // MARK: - Encode
        
        /// :nodoc:
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(traceId?.toHex, forKey: .traceId)
            try container.encode(spanId.toHex, forKey: .spanId)
            try container.encode(parentSpanId?.toHex, forKey: .parentSpanId)
            try container.encode(name, forKey: .name)
            try container.encode(kind, forKey: .kind)
            try container.encode(start, forKey: .start)
            try container.encode(end, forKey: .end)
            try container.encode(attribute, forKey: .attributes)
        }
        
        // MARK: - Copy
        
        /// :nodoc:
        public func copy(with zone: NSZone? = nil) -> Any {
            let copy = Span(
                traceId: traceId,
                spanId: spanId,
                name: name,
                start: start,
                end: end,
                attribute: attribute,
                kind: kind,
                parentSpanId: parentSpanId
            )
            
            return copy
        }
    }
}

/// Exclude class
extension TraceModel.Span {
    
    // MARK: - Description
    
    /// :nodoc:
    public override var description: String {
        return "\(type(of: self)) \(spanId) name: \(name.value), id: \(traceId ?? "nil"), is complete: \(end != nil)"
    }
}

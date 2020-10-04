//
//  TraceModel.swift
//  Trace
//
//  Created by Shams Ahmed on 10/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal protocol Traceable {
    
    // MARK: - Property
    
    var trace: TraceModel { get }
}

/// TraceModel
@objc(BRTraceModel)
@objcMembers
public final class TraceModel: NSObject, Codable {
    
    // MARK: - Enum
    
    private enum CodingKeys: CodingKey {
        case spans
        case resource
        case attributes
    }
    
    enum Error: Swift.Error {
        case incomplete
    }
    
    // MARK: - Property
    
    /// Must be 16 characters
    public let traceId: String
    
    /// All spans including the root
    public var spans: [Span]
    
    internal var resource: Resource?
    internal var attributes: [String: String]?
    
    private weak var _cachedRoot: Span?
    
    // MARK: - Computed
    
    /// Root
    var root: Span! {
        if let root = _cachedRoot {
            return root
        }
        
        let root = spans.first { $0.parentSpanId == nil }
        _cachedRoot = root
        
        return root
    }
    
    /// Is complete
    public var isComplete: Bool {
        return root.end != nil
    }
    
    // MARK: - Static - Start
    
    internal static func start(with name: String, time: Time.Timestamp = Time.timestamp) -> TraceModel {
        let traceId = UUID.random(16)
        let spanId = UUID.random(8)
        let root = Span(
            traceId: traceId,
            spanId: spanId,
            name: Span.Name(value: name, truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: time.seconds, nanos: time.nanos)
        )
        let trace = TraceModel(id: traceId, spans: [root])
        
        return trace
    }
    
    // MARK: - Init
    
    internal init(id traceId: String = UUID.random(16), spans: [Span], resource: Resource? = nil, attributes: [String: String]? = nil) {
        self.traceId = traceId
        self.spans = spans
        self.resource = resource
        self.attributes = attributes
        
        super.init()
        
        setup()
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        spans = try container.decode([Span].self, forKey: .spans)
        
        guard let id = spans.first?.traceId else { throw Error.incomplete }
        
        traceId = id
        resource = try container.decodeIfPresent(Resource.self, forKey: .resource)
        
        if resource == nil {
            Logger.print(.internalError, "Resource was not found in the existing trace model")
        }
        
        attributes = try container.decodeIfPresent([String: String].self, forKey: .attributes)
        
        super.init()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Encode
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let resource = resource {
            try container.encode(resource, forKey: .resource)
        } else {
            Logger.print(.internalError, "Resource missing from trace model")
        }
        
        if let attributes = attributes {
            try container.encode(attributes, forKey: .attributes)
        }
        
        try container.encode(spans, forKey: .spans)
    }
    
    // MARK: - End
    
    internal func finish(with timestamp: Time.Timestamp = Time.timestamp) {
        // finish trace session by recording a end time
        let zeroPointOne: Double = 100 // i.e 0.1 milliseconds
        let end = Span.Timestamp(seconds: timestamp.seconds, nanos: timestamp.nanos)
        
        spans
            .filter { $0.end == nil }
            .forEach {
                let start = $0.start
                let result = end - start
                let isGreaterThanOrEqualTo = result >= zeroPointOne
                
                if isGreaterThanOrEqualTo {
                    $0.end = end
                } else {
                    Logger.print(.internalError, "Span end timestamp rounded up by 0.1 milliseconds")
                    
                    let roundedUp = end + result
                    let roundedUpTimeStamp = Span.Timestamp(from: roundedUp)
                    
                    $0.end = roundedUpTimeStamp
                }
                
                #if DEBUG || Debug || debug
                // TODO: only for private beta testing. remove before GA
                if !$0.validate() {
                    Logger.print(.internalError, "Span has invalid timestamp")
                }
                #endif
            }
    }
}

/// Exclude class
extension TraceModel {
    
    // MARK: - Equatable
    
    /// :nodoc:
    public override func isEqual(_ object: Any?) -> Bool {
        let lhs = self
        
        guard let rhs = object as? TraceModel else { return false }
        
        return lhs.traceId == rhs.traceId
    }
    
    // MARK: - Description
    
    /// :nodoc:
    public override var description: String {
        return "Spans: \(spans.count), root: \(root.description)"
    }
}

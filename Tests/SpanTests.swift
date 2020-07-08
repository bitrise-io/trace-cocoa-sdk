//
//  SpanTests.swift
//  Tests
//
//  Created by Shams Ahmed on 11/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
import SnapshotTesting
@testable import Trace

final class SpanTests: XCTestCase {
    
    // MARK: - Property
    
    let start = Time.timestamp
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testSpan_init() {
        let end = Time.timestamp
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
        ])
        let root = TraceModel.Span(
            traceId: UUID.random(16),
            spanId: UUID.random(8),
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: start.seconds, nanos: start.nanos),
            end: TraceModel.Span.Timestamp(seconds: end.seconds, nanos: end.nanos),
            attribute: attribute
        )
        
        XCTAssertNotNil(root)
        XCTAssertNotNil(root.spanId)
        XCTAssertNotNil(root.name.value)
        
        XCTAssertEqual(root.traceId?.count, 16)
        XCTAssertEqual(root.spanId.count, 8)
    }
    
    func testSpan_init_three() {
        let end = Time.timestamp
        let attributes = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0)),
            TraceModel.Span.Attributes.Attribute(name: "br_test2", value: TraceModel.Span.Name(value: "test2", truncatedByteCount: 0)),
            TraceModel.Span.Attributes.Attribute(name: "br_test3", value: TraceModel.Span.Name(value: "test3", truncatedByteCount: 10))
        ])
        let root = TraceModel.Span(
            traceId: UUID.random(16),
            spanId: UUID.random(8),
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: start.seconds, nanos: start.nanos),
            end: TraceModel.Span.Timestamp(seconds: end.seconds, nanos: end.nanos),
            attribute: attributes
        )
        
        XCTAssertNotNil(root)
        XCTAssertNotNil(root.spanId)
        XCTAssertNotNil(root.name.value)
        
        XCTAssertEqual(root.traceId?.count, 16)
        XCTAssertEqual(root.spanId.count, 8)
    }
    
    func testSpan_encode() {
        let end = Time.timestamp
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
            ])
        let root = TraceModel.Span(
            traceId: UUID.random(16),
            spanId: UUID.random(8),
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: start.seconds, nanos: start.nanos),
            end: TraceModel.Span.Timestamp(seconds: end.seconds, nanos: end.nanos),
            attribute: attribute
        )
        
        let result = try? JSONEncoder().encode(root)
        
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.count ?? 0 >= 1)
    }
    
    func testSpan_decode() {
        let end = Time.timestamp
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
            ])
        let root = TraceModel.Span(
            traceId: UUID.random(16),
            spanId: UUID.random(8),
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: start.seconds, nanos: start.nanos),
            end: TraceModel.Span.Timestamp(seconds: end.seconds, nanos: end.nanos),
            attribute: attribute
        )
        
        XCTAssertNotNil(root)
        XCTAssertNotNil(root.spanId)
        XCTAssertNotNil(root.name.value)
        
        XCTAssertEqual(root.traceId?.count, 16)
        XCTAssertEqual(root.spanId.count, 8)
        
        let result = try? JSONEncoder().encode(root)
        
        XCTAssertNotNil(result)
        
        let model = try? JSONDecoder().decode(TraceModel.Span.self, from: result!)
        
        XCTAssertNotNil(model)
        XCTAssertEqual(model!.spanId, root.spanId)
        XCTAssertEqual(model!.traceId, model!.traceId)
        XCTAssertEqual(model!.name.value as! String, model!.name.value as! String)
    }
    
    func testSpan_json() {
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
            ])
        let root = TraceModel.Span(
            traceId: "1234",
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 002),
            attribute: attribute
        )
        
        assertSnapshot(matching: root, as: .json)
    }
    
    func testSpan_json_mulipleAttributes() {
        let attributes = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0)),
            TraceModel.Span.Attributes.Attribute(name: "br_test2", value: TraceModel.Span.Name(value: "test2", truncatedByteCount: 0)),
            TraceModel.Span.Attributes.Attribute(name: "br_test3", value: TraceModel.Span.Name(value: "test3", truncatedByteCount: 10))
        ])
        let root = TraceModel.Span(
            traceId: "1234",
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 002),
            attribute: attributes
        )
        
        assertSnapshot(matching: root, as: .json)
    }
}

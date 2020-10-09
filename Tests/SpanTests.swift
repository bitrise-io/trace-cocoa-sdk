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
    
    func testTimestampFromProtocol() {
        let timestamp = Time.from(Date(timeIntervalSince1970: 1))
        let convertedTimestamp = TraceModel.Span.Timestamp(from: timestamp)
        
        XCTAssertNotNil(timestamp)
        XCTAssertNotNil(convertedTimestamp)
        XCTAssertEqual(timestamp.seconds, convertedTimestamp.seconds)
        XCTAssertEqual(timestamp.nanos, convertedTimestamp.nanos)
    }
    
    func testTimestampFromProtocol_not_zeros() {
        let timestamp = Time.from(Date(timeIntervalSince1970: 99999999.9999))
        let convertedTimestamp = TraceModel.Span.Timestamp(from: timestamp)
        
        XCTAssertNotEqual(convertedTimestamp.seconds, 0)
        XCTAssertNotEqual(convertedTimestamp.nanos, 0)
        XCTAssertNotEqual(convertedTimestamp.seconds, convertedTimestamp.nanos)
    }
    
    func testEqual_true1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result1 = lhs == rhs
        let result2 = lhs != rhs
        
        XCTAssertTrue(result1)
        XCTAssertFalse(result2)
    }
    
    func testEqual_true2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100000000, nanos: 999999)
        let rhs = TraceModel.Span.Timestamp(seconds: 100000000, nanos: 99)
        
        let result1 = lhs == rhs
        let result2 = lhs != rhs
        
        XCTAssertFalse(result1)
        XCTAssertTrue(result2)
    }
    
    func testEqual_false1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100000000, nanos: 999999)
        let rhs = TraceModel.Span.Timestamp(seconds: 200000000, nanos: 11111)
        
        let result1 = lhs == rhs
        let result2 = lhs != rhs
        
        XCTAssertFalse(result1)
        XCTAssertTrue(result2)
    }
    
    func testEqual_false2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 200000000, nanos: 11111)
        let rhs = TraceModel.Span.Timestamp(seconds: 200000000, nanos: 11112)
        
        let result1 = lhs == rhs
        let result2 = lhs != rhs
        
        XCTAssertFalse(result1)
        XCTAssertTrue(result2)
    }
    
    func testMoreThan_false1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs > rhs
        
        XCTAssertFalse(result)
    }
    
    func testMoreThan_false2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 999999111, nanos: 100000)
        let rhs = TraceModel.Span.Timestamp(seconds: 999999111, nanos: 100000)
        
        let result = lhs > rhs
        
        XCTAssertFalse(result)
    }
    
    func testMoreThan_true1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 999999999, nanos: 100000)
        let rhs = TraceModel.Span.Timestamp(seconds: 999991111, nanos: 100000)
        
        let result = lhs > rhs
        
        XCTAssertTrue(result)
    }
    
    func testMoreThan_true2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 999999999, nanos: 200000)
        let rhs = TraceModel.Span.Timestamp(seconds: 999999999, nanos: 100000)
        
        let result = lhs > rhs
        
        XCTAssertTrue(result)
    }
    
    func testLessThan_false1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs < rhs
        
        XCTAssertFalse(result)
    }
    
    func testLessThan_false2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 111)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs < rhs
        
        XCTAssertFalse(result)
    }
    
    func testLessThan_true1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 10, nanos: 111)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs < rhs
        
        XCTAssertTrue(result)
    }
    
    func testLessThan_true2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 99)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs < rhs
        
        XCTAssertTrue(result)
    }
    
    func testMoreThan_true() {
        let lhs = TraceModel.Span.Timestamp(seconds: 200, nanos: 100)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs > rhs
        
        XCTAssertTrue(result)
    }
    
    func testLessThan_true() {
        let lhs = TraceModel.Span.Timestamp(seconds: 20, nanos: 100)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs < rhs
        
        XCTAssertTrue(result)
    }
    
    
    func testNotEqual_true1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 1000)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result1 = lhs != rhs
        let result2 = lhs != rhs
        
        XCTAssertTrue(result1)
        XCTAssertTrue(result2)
    }
    
    func testNotEqual_true2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100000000, nanos: 0000)
        let rhs = TraceModel.Span.Timestamp(seconds: 100000000, nanos: 1111)
        
        let result1 = lhs != rhs
        let result2 = lhs != rhs
        
        XCTAssertTrue(result1)
        XCTAssertTrue(result2)
    }
    
    // >=
    
    func testMoreThanOrEqualTo_false1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 899999111, nanos: 100000)
        let rhs = TraceModel.Span.Timestamp(seconds: 999999111, nanos: 100000)
        
        let result = lhs >= rhs
        
        XCTAssertFalse(result)
    }
    
    func testMoreThanOrEqualTo_true1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 999999999, nanos: 100000)
        let rhs = TraceModel.Span.Timestamp(seconds: 999991111, nanos: 100000)
        
        let result = lhs >= rhs
        
        XCTAssertTrue(result)
    }
    
    func testMoreThanOrEqualTo_true2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 999999999, nanos: 100000)
        let rhs = TraceModel.Span.Timestamp(seconds: 999999999, nanos: 100000)
        
        let result = lhs >= rhs
        
        XCTAssertTrue(result)
    }
    
    func testLessThanOrEqualTo_false1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 200, nanos: 111)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs <= rhs
        
        XCTAssertFalse(result)
    }
    
    func testLessThanOrEqualTo_true1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 10, nanos: 111)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs <= rhs
        
        XCTAssertTrue(result)
    }
    
    func testLessThanOrEqualTo_true2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        let rhs = TraceModel.Span.Timestamp(seconds: 100, nanos: 100)
        
        let result = lhs <= rhs
        
        XCTAssertTrue(result)
    }
    
    func testEqual_precision_false() {
        let lhs = TraceModel.Span.Timestamp(seconds: 1602084618, nanos: 940137)
        let rhs = TraceModel.Span.Timestamp(seconds: 1602084618, nanos: 94559)
        
        let result = lhs == rhs
        
        XCTAssertFalse(result)
    }
    
    func testEqual_precision_true1() {
        let lhs = TraceModel.Span.Timestamp(seconds: 1602084618, nanos: 940137)
        let rhs = TraceModel.Span.Timestamp(seconds: 1602084618, nanos: 94013)
        
        let result = lhs == rhs
        
        XCTAssertTrue(result)
    }
    
    func testEqual_precision_true2() {
        let lhs = TraceModel.Span.Timestamp(seconds: 1602084618, nanos: 940139)
        let rhs = TraceModel.Span.Timestamp(seconds: 1602084618, nanos: 94013)
        
        let result = lhs == rhs
        
        XCTAssertTrue(result)
    }
}

//
//  TraceTests.swift
//  Tests
//
//  Created by Shams Ahmed on 11/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class TraceModelTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testTrace_init() {
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
        ])
        let traceId = "1234"
        let span = TraceModel.Span(
            traceId: traceId,
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 002),
            attribute: attribute
        )
        let trace = TraceModel(id: traceId, spans: [span])
        
        XCTAssertNotNil(trace)
        XCTAssertEqual(trace.spans.count, 1)
    }
    
    func testTrace_decoderIsNil() {
        let trace = try? JSONDecoder().decode(TraceModel.self, from: Data())
        
        XCTAssertNil(trace)
    }
    
    func testTrace_decodeWithSpan() {
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
        ])
        let traceId = UUID.random(16)
        let span = TraceModel.Span(
            traceId: traceId,
            spanId: UUID.random(8),
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 002),
            attribute: attribute
        )
        let data = try? TraceModel(id: traceId, spans: [span]).json()
        
        XCTAssertNotNil(data)
        
        let trace = try? JSONDecoder().decode(TraceModel.self, from: data!)
        
        XCTAssertNotNil(trace)
        XCTAssertEqual(trace!.spans.count, 1)
        XCTAssertEqual(trace!.spans[0].spanId, span.spanId)
        XCTAssertEqual(trace!.spans[0].traceId, span.traceId)
    }
    
    func testTrace_json() {
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
        ])
        let traceId = "1234"
        let span = TraceModel.Span(
            traceId: traceId,
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 002),
            attribute: attribute
        )
        let trace = TraceModel(id: traceId, spans: [span])
        
        assertSnapshot(matching: trace, as: .json)
    }
    
    func testTrace_json_mulipleAttributes() {
        let attributes = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0)),
            TraceModel.Span.Attributes.Attribute(name: "br_test2", value: TraceModel.Span.Name(value: "test2", truncatedByteCount: 0)),
            TraceModel.Span.Attributes.Attribute(name: "br_test3", value: TraceModel.Span.Name(value: "test3", truncatedByteCount: 10))
        ])
        let traceId = "1234"
        let span = TraceModel.Span(
            traceId: traceId,
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 002),
            attribute: attributes
        )
        let trace = TraceModel(id: traceId, spans: [span])
        
        assertSnapshot(matching: trace, as: .json)
    }
    
    func testTrace_json_withAttributes() {
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
        ])
        let traceId = "1234"
        let span = TraceModel.Span(
            traceId: traceId,
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 002),
            attribute: attribute
        )
        let attributes = ["test1": "test2"]
        let trace = TraceModel(id: traceId, spans: [span], attributes: attributes)
        
        assertSnapshot(matching: trace, as: .json)
    }
    
    func testContainsPropertyWithSpan() {
        let span = TraceModel.Span(
            traceId: "xxx",
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001)
        )
        let model = TraceModel(spans: [span])
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertEqual(model.root.spanId, span.spanId)
        XCTAssertFalse(model.isComplete)
    }
    
    func testContainsPropertyWithInit() {
        let span = TraceModel.Span(
            traceId: "xxx",
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001)
        )
        let model = TraceModel(id: "id", spans: [span], resource: nil, attributes: nil)
        let root = model.root
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertEqual(root?.spanId, model.root.spanId)
        XCTAssertEqual(model.root.spanId, span.spanId)
        XCTAssertFalse(model.isComplete)
    }
    
    func testContainsPropertyWithStart() {
        let model = TraceModel.start(with: "start")
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertFalse(model.isComplete)
    }
    
    func testContainsPropertyWithSpan_finish() {
        let span = TraceModel.Span(
            traceId: "xxx",
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001)
        )
        let model = TraceModel(spans: [span])
        model.finish()
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertEqual(model.root.spanId, span.spanId)
        XCTAssertTrue(model.isComplete)
    }
    
    func testContainsPropertyWithInit_finish() {
        let span = TraceModel.Span(
            traceId: "xxx",
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001)
        )
        let model = TraceModel(id: "id", spans: [span], resource: nil, attributes: nil)
        model.finish()
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertEqual(model.root.spanId, span.spanId)
        XCTAssertTrue(model.isComplete)
    }
    
    func testContainsPropertyWithStart_finish() {
        let model = TraceModel.start(with: "start")
        model.finish()
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertTrue(model.isComplete)
    }
    
    func testContainsPropertyWithStart_finishFewTimes() {
        let model = TraceModel.start(with: "start")
        model.finish()
        model.finish()
        model.finish()
        model.finish()
        model.finish()
        model.finish()
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertTrue(model.isComplete)
    }
    
    func testCreatingLoadsOfModels_100() {
        for i in 0...100 {
            let model = TraceModel.start(with: "start \(i)")
            let root = model.root
            model.finish()
            
            XCTAssertNotNil(model.traceId)
            XCTAssertFalse(model.spans.isEmpty)
            XCTAssertNotNil(model.root)
            XCTAssertEqual(model.root.spanId, root?.spanId)
            XCTAssertTrue(model.isComplete)
        }
    }
    
    func testCreatingLoadsOfModels_1000() {
        for i in 0...1000 {
            let model = TraceModel.start(with: "start \(i)")
            model.finish()
            
            XCTAssertNotNil(model.traceId)
            XCTAssertFalse(model.spans.isEmpty)
            XCTAssertNotNil(model.root)
            XCTAssertTrue(model.isComplete)
        }
    }
    
    func testCreatingLoadsOfSpanModels_100() {
        let model = TraceModel.start(with: "start")
        let root1 = model.root
        
        for i in 0...100 {
            let span = TraceModel.Span(
                traceId: "xxx",
                spanId: "id \(i)",
                name: TraceModel.Span.Name(value: "test \(i)", truncatedByteCount: 0),
                start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001)
            )
            
            model.spans.append(span)
        }
        
        let root2 = model.root
        
        model.finish()
        
        let root3 = model.root
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertEqual(model.root.spanId, model.root.spanId)
        XCTAssertEqual(model.root.spanId, root1?.spanId)
        XCTAssertEqual(model.root.spanId, root2?.spanId)
        XCTAssertEqual(model.root.spanId, root3?.spanId)
        XCTAssertEqual(model.spans.count, 102)
        XCTAssertTrue(model.isComplete)
    }
    
    func testCreatingLoadsOfSpanModels_1000() {
        let model = TraceModel.start(with: "start")
        
        for i in 0...1000 {
            let span = TraceModel.Span(
                traceId: "xxx",
                spanId: "id \(i)",
                name: TraceModel.Span.Name(value: "test \(i)", truncatedByteCount: 0),
                start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001)
            )
            
            model.spans.append(span)
        }
        
        model.finish()
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertEqual(model.spans.count, 1002)
        XCTAssertTrue(model.isComplete)
    }
    
    func testCreatingLoadsOfSpanModels_5000() {
        let model = TraceModel.start(with: "start")
        
        for i in 0...5000 {
            let span = TraceModel.Span(
                traceId: "xxx",
                spanId: "id \(i)",
                name: TraceModel.Span.Name(value: "test \(i)", truncatedByteCount: 0),
                start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001)
            )
            
            model.spans.append(span)
        }
        
        model.finish()
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertEqual(model.spans.count, 5002)
        XCTAssertTrue(model.isComplete)
    }
}

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
        let trace = TraceModel(id: traceId, spans: [span], type: .view)
        
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
        let data = try? TraceModel(id: traceId, spans: [span], type: .view).json()
        
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
        let trace = TraceModel(id: traceId, spans: [span], type: .view)
        
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
        let trace = TraceModel(id: traceId, spans: [span], type: .view)
        
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
        let trace = TraceModel(id: traceId, spans: [span], attributes: attributes, type: .view)
        
        assertSnapshot(matching: trace, as: .json)
    }
    
    func testContainsPropertyWithSpan() {
        let span = TraceModel.Span(
            traceId: "xxx",
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 100, nanos: 001)
        )
        let model = TraceModel(spans: [span], type: .view)
        
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
        let model = TraceModel(id: "id", spans: [span], resource: nil, attributes: nil, type: .view)
        let root = model.root
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertEqual(root?.spanId, model.root.spanId)
        XCTAssertEqual(model.root.spanId, span.spanId)
        XCTAssertFalse(model.isComplete)
    }
    
    func testContainsPropertyWithStart() {
        let model = TraceModel.start(with: "start", type: .view)
        
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
        let model = TraceModel(spans: [span], type: .view)
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
        let model = TraceModel(id: "id", spans: [span], resource: nil, attributes: nil, type: .view)
        model.finish()
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertEqual(model.root.spanId, span.spanId)
        XCTAssertTrue(model.isComplete)
    }
    
    func testContainsPropertyWithStart_finish() {
        let model = TraceModel.start(with: "start", type: .view)
        model.finish()
        
        XCTAssertNotNil(model.traceId)
        XCTAssertFalse(model.spans.isEmpty)
        XCTAssertNotNil(model.root)
        XCTAssertTrue(model.isComplete)
    }
    
    func testContainsPropertyWithStart_finishFewTimes() {
        let model = TraceModel.start(with: "start", type: .view)
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
            let model = TraceModel.start(with: "start \(i)", type: .view)
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
            let model = TraceModel.start(with: "start \(i)", type: .view)
            model.finish()
            
            XCTAssertNotNil(model.traceId)
            XCTAssertFalse(model.spans.isEmpty)
            XCTAssertNotNil(model.root)
            XCTAssertTrue(model.isComplete)
        }
    }
    
    func testCreatingLoadsOfSpanModels_100() {
        let model = TraceModel.start(with: "start", type: .view)
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
        let model = TraceModel.start(with: "start", type: .view)
        
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
        let model = TraceModel.start(with: "start", type: .view)
        
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
    
    func testTraceSpan_valid() {
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
        
        XCTAssert(span.validate())
        XCTAssertNotNil(span.description)
        XCTAssertNotNil(span.debugDescription)
        XCTAssertNotNil(span.snapshotDescription)
    }
    
    func testTraceSpan_invalidBySeconds() {
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
        ])
        let traceId = "1234"
        let span = TraceModel.Span(
            traceId: traceId,
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 300, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 002),
            attribute: attribute
        )
        
        XCTAssertFalse(span.validate())
    }
    
    func testTraceSpan_invalidByNanos() {
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
        ])
        let traceId = "1234"
        let span = TraceModel.Span(
            traceId: traceId,
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 200, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 000),
            attribute: attribute
        )
        
        XCTAssertFalse(span.validate())
    }
    
    func testTraceSpan_invalidBySameTime() {
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
        ])
        let traceId = "1234"
        let span = TraceModel.Span(
            traceId: traceId,
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 200, nanos: 001),
            end: TraceModel.Span.Timestamp(seconds: 200, nanos: 001),
            attribute: attribute
        )
        
        XCTAssertFalse(span.validate())
    }
    
    func testTraceSpan_invalidByNoEndTime() {
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: "br_test1", value: TraceModel.Span.Name(value: "test", truncatedByteCount: 0))
        ])
        let traceId = "1234"
        let span = TraceModel.Span(
            traceId: traceId,
            spanId: "1234",
            name: TraceModel.Span.Name(value: "test", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 200, nanos: 001),
            end: nil,
            attribute: attribute
        )
        
        XCTAssertFalse(span.validate())
    }
    
    func testIsEqual_true() {
        let model = TraceModel.start(with: "1", type: .view)
        let result = model == model
        
        XCTAssertEqual(model, model)
        XCTAssertTrue(result)
    }
    
    func testIsEqual_false() {
        let model1 = TraceModel.start(with: "1", type: .view)
        let model2 = TraceModel.start(with: "2", type: .view)
        let result = model1 == model2
        
        XCTAssertNotEqual(model1, model2)
        XCTAssertFalse(result)
    }
    
    func testIsEqual_contains_true() {
        let model = TraceModel.start(with: "1", type: .view)
        let models = [model]
        
        let result1 = models.contains(model)
        let result2 = models.contains { $0 == model }
        
        XCTAssertTrue(result1)
        XCTAssertTrue(result2)
    }
    
    func testIsEqual_contains_false() {
        let model1 = TraceModel.start(with: "1", type: .view)
        let model2 = TraceModel.start(with: "2", type: .view)
        let model3 = TraceModel.start(with: "3", type: .view)
        let models = [model1, model2, model3]
        
        let newModel = TraceModel.start(with: "4", type: .view)
        
        let result1 = models.contains(newModel)
        let result2 = models.contains { $0 == newModel }
        
        XCTAssertFalse(result1)
        XCTAssertFalse(result2)
    }
    
    func testTraceModel_finish_positive_timestamp() {
        let model = TraceModel.start(with: "start", type: .view)
        model.finish()
        
        XCTAssertEqual(model.spans.count, 1)
        XCTAssertNotNil(model.spans[0].end)
    }
    
    func testTraceModel_finish_negative_timestamp() {
        let pastTime = Time.from(Date(timeIntervalSince1970: 1))
        
        let model = TraceModel.start(with: "start", type: .view)
        model.finish(with: pastTime)
        
        XCTAssertEqual(model.spans.count, 1)
        XCTAssertNotNil(model.spans[0].end)
    }
    
    func testTrace_snapshot() {
        let id = "7530566f6638343046575a6c7761594d"
        let sId = "31444d675946645a"
        let span = TraceModel.Span(
            traceId: id,
            spanId: sId,
            name: TraceModel.Span.Name(value: "TraceModel start", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1)
        )
        let model = TraceModel(id: id, spans: [span], resource: nil, attributes: nil, type: .startup)
        
        assertSnapshot(matching: model, as: .json)
    }
    
    func testTrace_snapshot_spans() {
        let id = "7530566f6638343046575a6c7761594d"
        let sId = "31444d675946645a"
        let span = TraceModel.Span(
            traceId: id,
            spanId: sId,
            name: TraceModel.Span.Name(value: "TraceModel start", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1)
        )
        let model = TraceModel(id: id, spans: [span], resource: nil, attributes: nil, type: .startup)
        
        assertSnapshot(matching: model.spans, as: .json)
    }
    
    func testTrace_snapshot_finish() {
        let span = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "wrcwrwrewr",
            name: TraceModel.Span.Name(value: "TraceModel finish", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1)
        )
        let model = TraceModel(id: "gs45634tttre", spans: [span], resource: nil, attributes: nil, type: .startup)
        model.finish(with: Time.Timestamp(seconds: 123, nanos: 100, timeInterval: 123.100))
        
        assertSnapshot(matching: model, as: .json)
    }
    
    func testTrace_snapshot_finish_span() {
        let span = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "wrcwrwrewr",
            name: TraceModel.Span.Name(value: "TraceModel finish", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1)
        )
        let model = TraceModel(id: "gs45634tttre", spans: [span], resource: nil, attributes: nil, type: .startup)
        model.finish(with: Time.Timestamp(seconds: 123, nanos: 100, timeInterval: 123.100))
        
        assertSnapshot(matching: model, as: .json)
        assertSnapshot(matching: model.spans, as: .json)
    }
    
    func testTrace_snapshot_finish_with_spans() {
        let span = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "wrcwrwrewr",
            name: TraceModel.Span.Name(value: "TraceModel finish", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1)
        )
        let model = TraceModel(id: "gs45634tttre", spans: [span], resource: nil, attributes: nil, type: .startup)
        let span2 = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "new2",
            name: TraceModel.Span.Name(value: "name", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1),
            end: TraceModel.Span.Timestamp(seconds: 123, nanos: 100),
            attribute: TraceModel.Span.Attributes(),
            kind: .client,
            parentSpanId: "wrcwrwrewr"
        )
        
        model.spans.append(span2)
        model.finish(with: Time.Timestamp(seconds: 123, nanos: 100, timeInterval: 123.100))
        
        assertSnapshot(matching: model, as: .json)
        assertSnapshot(matching: model.spans, as: .json)
    }
    
    func testTrace_snapshot_finish_withMany_spans() {
        let span = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "wrcwrwrewr",
            name: TraceModel.Span.Name(value: "TraceModel finish", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1)
        )
        let model = TraceModel(id: "gs45634tttre", spans: [span], resource: nil, attributes: nil, type: .startup)
        let span2 = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "new2",
            name: TraceModel.Span.Name(value: "name", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1),
            end: TraceModel.Span.Timestamp(seconds: 123, nanos: 100),
            attribute: TraceModel.Span.Attributes(),
            kind: .client,
            parentSpanId: "wrcwrwrewr"
        )
        let span3 = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "new3",
            name: TraceModel.Span.Name(value: "name 3", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 10, nanos: 1),
            end: TraceModel.Span.Timestamp(seconds: 143, nanos: 100),
            attribute: TraceModel.Span.Attributes(),
            kind: .unspecified,
            parentSpanId: "wrcwrwrewr"
        )
        
        model.spans.append(span2)
        model.spans.append(span3)
        model.finish(with: Time.Timestamp(seconds: 123, nanos: 100, timeInterval: 123.100))
        
        assertSnapshot(matching: model, as: .json)
    }
    
    func testTrace_snapshot_finish_withMany_spansCheck() {
        let span = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "wrcwrwrewr",
            name: TraceModel.Span.Name(value: "TraceModel finish", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1)
        )
        let model = TraceModel(id: "gs45634tttre", spans: [span], resource: nil, attributes: nil, type: .startup)
        let span2 = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "new2",
            name: TraceModel.Span.Name(value: "name", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1),
            end: TraceModel.Span.Timestamp(seconds: 123, nanos: 100),
            attribute: TraceModel.Span.Attributes(),
            kind: .client,
            parentSpanId: "wrcwrwrewr"
        )
        let span3 = TraceModel.Span(
            traceId: "gs45634tttre",
            spanId: "new3",
            name: TraceModel.Span.Name(value: "name 3", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 10, nanos: 1),
            end: TraceModel.Span.Timestamp(seconds: 143, nanos: 100),
            attribute: TraceModel.Span.Attributes(),
            kind: .unspecified,
            parentSpanId: "wrcwrwrewr"
        )
        
        model.spans.append(span2)
        model.spans.append(span3)
        model.finish(with: Time.Timestamp(seconds: 123, nanos: 100, timeInterval: 123.100))
        
        assertSnapshot(matching: model.spans, as: .json)
    }
    
    func testTrace_snapshot_resourceAndAttributes() {
        let resource = Resource(from: [], sessionId: "123")
        let span = TraceModel.Span(
            traceId: "7530566f6638343046575a6c7761594d",
            spanId: "31444d675946645a",
            name: TraceModel.Span.Name(value: "TraceModel start", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1)
        )
        let attributes = [
            "At1": "v1",
            "At2": "v2",
            "At3": "v3"
        ]
        let model = TraceModel(
            id: "7530566f6638343046575a6c7761594d",
            spans: [span],
            resource: resource,
            attributes: attributes,
            type: .startup
        )
        
        assertSnapshot(matching: model, as: .json)
    }
    
    func testTrace_snapshot_resourceAndAttributes_spans() {
        let resource = Resource(from: [], sessionId: "123")
        let span = TraceModel.Span(
            traceId: "7530566f6638343046575a6c7761594d",
            spanId: "31444d675946645a",
            name: TraceModel.Span.Name(value: "TraceModel start", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 0, nanos: 1)
        )
        let attributes = [
            "At1": "v1",
            "At2": "v2",
            "At3": "v3"
        ]
        let model = TraceModel(
            id: "7530566f6638343046575a6c7761594d",
            spans: [span],
            resource: resource,
            attributes: attributes,
            type: .startup
        )
        
        assertSnapshot(matching: model.spans, as: .json)
    }
}

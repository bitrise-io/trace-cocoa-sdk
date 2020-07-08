//
//  TracerTest.swift
//  Tests
//
//  Created by Shams Ahmed on 01/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
import SnapshotTesting
@testable import Trace

final class TracerTests: XCTestCase {
    
    // MARK: - Property
    
    let tracer: Tracer = {
        let network = Network()
        let database = Database()
        let session = Session()
        let scheduler = Scheduler(with: network)
        let queue = Queue(with: scheduler, database, session)
        let tracer = Tracer(with: queue, session)
        
        return tracer
    }()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testTracer_add() {
        XCTAssertEqual(tracer.traces.count, 0)
        
        let trace = TraceModel.start(with: "test")
        
        tracer.traces.append(trace)
        
        XCTAssertEqual(tracer.traces.count, 1)
    }
    
    func testTracer_add100() {
        for i in 0...100 {
            let trace = TraceModel.start(with: "test \(i)")
            
            tracer.traces.append(trace)
        }
        
        XCTAssertEqual(tracer.traces.count, 101)
    }
    
    func testTracer_add1000() {
        for i in 0...1000 {
            let trace = TraceModel.start(with: "test \(i)")
            
            tracer.traces.append(trace)
        }
        
        XCTAssertEqual(tracer.traces.count, 1001)
    }
    
    func testTracer_addChildSpan() {
        XCTAssertEqual(tracer.traces.count, 0)
        
        let span = TraceModel.Span(
            name: TraceModel.Span.Name(value: "span", truncatedByteCount: 0),
            start: TraceModel.Span.Timestamp(seconds: 1, nanos: 1),
            end: TraceModel.Span.Timestamp(seconds: 1, nanos: 1)
        )
        
        tracer.traces.append(.start(with: "test0"))
        tracer.addChild([span])
        
        XCTAssertNil(tracer.traces.filter { $0.spans.isEmpty }.first)
    }
    
    func testTracer_addChildSpan_100() {
        tracer.traces.append(.start(with: "test 100"))
        
        for i in 0...100 {
            let span = TraceModel.Span(
                name: TraceModel.Span.Name(value: "span \(i)", truncatedByteCount: 0),
                start: TraceModel.Span.Timestamp(seconds: 1, nanos: 1)
            )
            
            tracer.addChild([span])
        }
        
        tracer.finishAll()
        
        XCTAssertNil(tracer.traces.filter { $0.spans.isEmpty }.first)
    }
    
    func testTracer_addChildSpan_1000() {
        tracer.traces.append(.start(with: "test 1000"))
        
        for i in 0...1000 {
            let span = TraceModel.Span(
                name: TraceModel.Span.Name(value: "span \(i)", truncatedByteCount: 0),
                start: TraceModel.Span.Timestamp(seconds: 1, nanos: 1)
            )
            
            tracer.addChild([span])
        }
        
        tracer.finishAll()
        
        XCTAssertNil(tracer.traces.filter { $0.spans.isEmpty }.first)
    }
    
    func testTracer_addChildSpan_1500() {
        tracer.traces.append(.start(with: "test 10000"))
        
        for i in 0...1500 {
            let span = TraceModel.Span(
                name: TraceModel.Span.Name(value: "span \(i)", truncatedByteCount: 0),
                start: TraceModel.Span.Timestamp(seconds: 1, nanos: 1)
            )
            
            tracer.addChild([span])
        }
        
        tracer.finishAll()
        
        XCTAssertNil(tracer.traces.filter { $0.spans.isEmpty }.first)
    }
    
    func testTracer_finish() {
        XCTAssertEqual(tracer.traces.count, 0)
        
        let trace = TraceModel.start(with: "test1")
        
        XCTAssertFalse(trace.isComplete)
        
        tracer.traces.append(trace)
        tracer.finish(trace)
        
        XCTAssertTrue(trace.isComplete)
    }
    
    func testTracer_finishOne() {
        XCTAssertEqual(tracer.traces.count, 0)
        
        let trace1 = TraceModel.start(with: "test1")
        let trace2 = TraceModel.start(with: "test2")
        
        XCTAssertFalse(trace1.isComplete)
        XCTAssertFalse(trace2.isComplete)
        
        tracer.traces.append(trace1)
        tracer.traces.append(trace2)
        tracer.finish(trace1)
        
        XCTAssertTrue(trace1.isComplete)
        XCTAssertFalse(trace2.isComplete)
        
        XCTAssertNotNil(tracer.traces.filter { !$0.isComplete }.first)
    }
    
    func testTracer_finishAll() {
        XCTAssertEqual(tracer.traces.count, 0)
        
        let trace = TraceModel.start(with: "test2")
        
        XCTAssertFalse(trace.isComplete)
        
        tracer.traces.append(trace)
        tracer.finishAll()
        
        XCTAssertTrue(trace.isComplete)
        
        XCTAssertNil(tracer.traces.filter { !$0.isComplete }.first)
    }
    
    func testTracer_finishAll_MultipleTimes() {
        XCTAssertEqual(tracer.traces.count, 0)
        
        let trace = TraceModel.start(with: "test2")
        
        XCTAssertFalse(trace.isComplete)
        
        tracer.traces.append(trace)
        tracer.finishAll()
        tracer.finishAll()
        tracer.finishAll()
        tracer.finishAll()
        tracer.finishAll()
        tracer.finishAll()
        
        XCTAssertTrue(trace.isComplete)
        
        XCTAssertNil(tracer.traces.filter { !$0.isComplete }.first)
    }
}

//
//  CrashFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class CrashFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let crash = CrashFormatter(CrashReporting.Report(
        type: .exception,
        name: "someCrash",
        reason: "someReason",
        callStack: "CallStack..."
        )
    )
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testReport() {
        let report = CrashReporting.Report(
            type: .exception,
            name: "someCrash",
            reason: "someReason",
            callStack: "CallStack..."
        )
        
        XCTAssertNotNil(report)
        XCTAssertEqual(report.type, .exception)
        XCTAssertEqual(report.callStack, "CallStack...")
        XCTAssertNotNil(report.timestamp)
        XCTAssertNotNil(report.timestamp.nanos)
        XCTAssertNotNil(report.timestamp.seconds)
        XCTAssertGreaterThanOrEqual(report.timestamp.nanos, 0)
        XCTAssertGreaterThanOrEqual(report.timestamp.seconds, 0)
    }
    
    func testErrorNil() {
        let data = crash.data
        let json = crash.jsonString
        let string = String(data: data!, encoding: .utf8)!
        
        XCTAssertNotNil(crash)
        XCTAssertNotNil(data)
        XCTAssertTrue(string.contains("type"))
        XCTAssertTrue(string.contains("someReason"))
        XCTAssertTrue(string.contains("someCrash"))
        XCTAssertTrue(json.contains("type"))
        XCTAssertTrue(json.contains("someReason"))
        XCTAssertTrue(json.contains("someCrash"))
    }
    
    func testReadMetrics() {
        let metrics = crash.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    
    func testReadMetrics_readOne() {
        let metric = crash.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.appCrashTotal)
        
        XCTAssertEqual(metric.timeseries.count, 1)
    }
    
    func testReadMetrics_readPoints() {
        let points = crash.metrics.metrics.first!.timeseries[0].points
        let point = crash.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
        
        XCTAssertEqual(point.value as! Int, 1)
    }
    
    func testReadMetrics_readValues() {
        let values = crash.metrics.metrics.first!.timeseries[0].values
        let value = crash.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 1)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: crash.metrics.metrics[0].descriptor, as: .json)
    }
    
    func testSpans_readValues() {
        let spans = crash.spans
        let span = crash.spans[0]
        
        XCTAssertEqual(spans.count, 1)
        XCTAssertEqual(span.name.value as! String, "someCrash")
        XCTAssertEqual(span.attribute.attribute.count, 2)
    }
}

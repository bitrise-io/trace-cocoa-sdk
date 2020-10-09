//
//  StartupFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class StartupFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let startup = StartupFormatter(1.0, status: .cold)
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(startup)
        XCTAssertNotNil(startup.data)
        XCTAssertNotNil(startup.jsonString)
    }
    
    func testReadTrace_cold() {
        let trace = startup.trace
        
        XCTAssertNotNil(trace)
        XCTAssertNotNil(trace.description)
        XCTAssertNotNil(trace.root)
    }
    
    func testReadTrace_warm() {
        let startup = StartupFormatter.init(Time.timestamp, status: .warm)
        let trace = startup.trace
        
        XCTAssertNotNil(trace)
        XCTAssertNotNil(trace.description)
        XCTAssertNotNil(trace.root)
    }
    
    func testReadMetrics() {
        let metrics = startup.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    func testReadMetrics_readOne() {
        let metric = startup.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.appStartupLatencyMS)
        
        XCTAssertEqual(metric.timeseries.count, 1)
    }
    
    func testReadMetrics_readPoints() {
        let points = startup.metrics.metrics.first!.timeseries[0].points
        let point = startup.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }
    
    func testReadMetrics_readValues() {
        let values = startup.metrics.metrics.first!.timeseries[0].values
        let value = startup.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 1)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: startup.metrics.metrics[0].descriptor, as: .json)
    }
}

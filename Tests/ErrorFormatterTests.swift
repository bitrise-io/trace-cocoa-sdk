//
//  ErrorFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class ErrorFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let error = ErrorFormatter(domain: "mydomain", code: 123, userinfo: ["test": "test"], metadata: ["sdk": "issue1"])
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(error)
        XCTAssertNotNil(error.data)
        XCTAssertNotNil(error.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = error.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    func testReadMetrics_noReason() {
        let error = ErrorFormatter(domain: "", code: 1, userinfo: nil)
        let reason = error.details["reason"]
        
        XCTAssertTrue(reason?.isEmpty == true)
    }
    
    func testReadMetrics_readOne() {
        let metric = error.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.appErrorTotal)
        
        XCTAssertEqual(metric.timeseries.count, 1)
    }
    
    func testReadMetrics_readPoints() {
        let points = error.metrics.metrics.first!.timeseries[0].points
        let point = error.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
        
        XCTAssertEqual(point.value as! Int, 1)
    }
    
    func testReadMetrics_readValues() {
        let values = error.metrics.metrics.first!.timeseries[0].values
        let value = error.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 1)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: error.metrics.metrics[0].descriptor, as: .json)
    }
}

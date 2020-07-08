//
//  RequestFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class RequestFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let request = RequestFormatter(URLRequest(url: URL(string: "https://bitrise.io")!))
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(request)
        XCTAssertNotNil(request.data)
        XCTAssertNotNil(request.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = request.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        XCTAssertNotNil(request.details)
        
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    func testReadMetrics_readOne() {
        let metric = request.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.appPrerequestTotal)
        
        XCTAssertEqual(metric.timeseries.count, 1)
        XCTAssertNotNil(request.details)
    }
    
    func testReadMetrics_readPoints() {
        let points = request.metrics.metrics.first!.timeseries[0].points
        let point = request.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }
    
    func testReadMetrics_readValues() {
        let values = request.metrics.metrics.first!.timeseries[0].values
        let value = request.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 3)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: request.metrics.metrics[0].descriptor, as: .json)
    }
}

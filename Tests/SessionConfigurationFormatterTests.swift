//
//  SessionConfigurationFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class SessionConfigurationFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let session = SessionConfigurationFormatter(.default)
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(session)
        XCTAssertNotNil(session.data)
        XCTAssertNotNil(session.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = session.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        XCTAssertNotNil(session.details)
        
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    func testReadMetrics_readOne() {
        let metric = session.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.httpSessionConfiguration)
        
        XCTAssertEqual(metric.timeseries.count, 1)
        XCTAssertNotNil(session.details)
    }
    
    func testReadMetrics_readPoints() {
        let points = session.metrics.metrics.first!.timeseries[0].points
        let point = session.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }
    
    func testReadMetrics_readValues() {
        let values = session.metrics.metrics.first!.timeseries[0].values
        let value = session.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 8)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: session.metrics.metrics[0].descriptor, as: .json)
    }
}

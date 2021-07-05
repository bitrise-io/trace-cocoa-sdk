//
//  FPSFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class FPSFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let fps = FPSFormatter(FPS.Result(timestamp: Time.timestamp, fps: 60, viewController: "VC"))
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(fps)
        XCTAssertNotNil(fps.data)
        XCTAssertNotNil(fps.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = fps.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        XCTAssertNotNil(fps.details)
        
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    func testReadMetrics_readOne() {
        let metric = fps.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.viewFrameRate)
        
        XCTAssertEqual(metric.timeseries.count, 1)
        XCTAssertNotNil(fps.details)
    }
    
    func testReadMetrics_readPoints() {
        let points = fps.metrics.metrics.first!.timeseries[0].points
        let point = fps.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }
    
    func testReadMetrics_readValues() {
        let values = fps.metrics.metrics.first!.timeseries[0].values
        let value = fps.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 1)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: fps.metrics.metrics[0].descriptor, as: .json)
    }
    
    func testDescriptor_snapshot() {
        let timestamp = Time.Timestamp(seconds: 123, nanos: 22200, timeInterval: 123.22200)
        let formatter = FPSFormatter(FPS.Result(timestamp: timestamp, fps: 47, viewController: "CustomViewController"))
        let metric = formatter.metrics.metrics.first!
        
        assertSnapshot(matching: metric.descriptor, as: .json)
    }
}

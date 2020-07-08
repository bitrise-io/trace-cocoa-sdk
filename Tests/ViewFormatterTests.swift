//
//  ViewFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class ViewFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let metric = UIView.Metric(name: "view")
    lazy var view = ViewFormatter(metric)
    
    // MARK: - Setup
    
    override func setUp() {
        metric.initWithCoder = Time.timestamp
        metric.initWithFrame = Time.timestamp
        metric.layoutSubviews = Time.timestamp
        metric.draw = Time.timestamp
        metric.didMoveToSuperview = Time.timestamp
        metric.didMoveToWindow = Time.timestamp
        metric.removeFromSuperview = Time.timestamp
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(view)
        XCTAssertNotNil(view.data)
        XCTAssertNotNil(view.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = view.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        XCTAssertNotNil(view.details)
        
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    func testReadMetrics_frame() {
        let metric = UIView.Metric(name: "view2")
        metric.initWithFrame = Time.timestamp
        
        let view = ViewFormatter(metric)
        
        XCTAssertNotNil(view)
        XCTAssertNil(view.metrics.resource)
        XCTAssertNotNil(view.details)
        
        XCTAssertEqual(view.metrics.metrics.count, 1)
    }
    
    func testReadMetrics_coder() {
        let metric = UIView.Metric(name: "view2")
        metric.initWithCoder = Time.timestamp
        
        let view = ViewFormatter(metric)
        
        XCTAssertNotNil(view)
        XCTAssertNil(view.metrics.resource)
        XCTAssertNotNil(view.details)
        
        XCTAssertEqual(view.metrics.metrics.count, 1)
    }

    func testReadMetrics_readOne() {
        let metric = view.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.subviewRenderLatencyMS)
        
        XCTAssertEqual(metric.timeseries.count, 5)
        XCTAssertNotNil(view.details)
    }
    
    func testReadMetrics_readPoints() {
        let points = view.metrics.metrics.first!.timeseries[0].points
        let point = view.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }
    
    func testReadMetrics_readValues() {
        let values = view.metrics.metrics.first!.timeseries[0].values
        let value = view.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 2)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: view.metrics.metrics[0].descriptor, as: .json)
    }
}

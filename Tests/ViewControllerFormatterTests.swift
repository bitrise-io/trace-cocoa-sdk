//
//  ViewControllerFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class ViewControllerFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let metric = UIViewController.Metric()
    lazy var viewController = ViewControllerFormatter(metric)
    
    // MARK: - Setup
    
    override func setUp() {
        metric.name = "ViewController"
        metric.awakeFromNib = Time.timestamp
        metric.loadView = Time.timestamp
        metric.viewDidLoad = Time.timestamp
        metric.viewWillAppear = Time.timestamp
        metric.viewDidAppear = Time.timestamp
        metric.viewWillLayoutSubviews = Time.timestamp
        metric.viewDidLayoutSubviews = Time.timestamp
        metric.viewWillDisappear = Time.timestamp
        metric.viewDidDisappear = Time.timestamp
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController.data)
        XCTAssertNotNil(viewController.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = viewController.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        XCTAssertNotNil(viewController.details)
        
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    func testReadMetrics_init() {
        let metric = UIViewController.Metric()
        let viewController = ViewControllerFormatter(metric)
        
        metric.name = "ViewController2"
        metric.`init` = Time.timestamp
     
        XCTAssertEqual(viewController.metrics.metrics.count, 1)
        XCTAssertNotNil(viewController.details)
    }
    
    func testReadMetrics_coder() {
        let metric = UIViewController.Metric()
        let viewController = ViewControllerFormatter(metric)
        
        metric.name = "ViewController2"
        metric.initWithCoder = Time.timestamp
        
        XCTAssertEqual(viewController.metrics.metrics.count, 1)
        XCTAssertNotNil(viewController.details)
    }
    
    func testReadMetrics_nib() {
        let metric = UIViewController.Metric()
        let viewController = ViewControllerFormatter(metric)
        
        metric.name = "ViewController2"
        metric.initWithNib = Time.timestamp
        
        XCTAssertEqual(viewController.metrics.metrics.count, 1)
        XCTAssertNotNil(viewController.details)
    }
    
    func testReadMetrics_awake() {
        let metric = UIViewController.Metric()
        let viewController = ViewControllerFormatter(metric)
        
        metric.name = "ViewController2"
        metric.awakeFromNib = Time.timestamp
        
        XCTAssertEqual(viewController.metrics.metrics.count, 1)
        XCTAssertNotNil(viewController.details)
    }
    
    func testReadMetrics_readOne() {
        let metric = viewController.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.appRequestSizeBytes)
        
        XCTAssertEqual(metric.timeseries.count, 9)
        XCTAssertNotNil(viewController.details)
    }
    
    func testReadMetrics_readPoints() {
        let points = viewController.metrics.metrics.first!.timeseries[0].points
        let point = viewController.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }
    
    func testReadMetrics_readValues() {
        let values = viewController.metrics.metrics.first!.timeseries[0].values
        let value = viewController.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 2)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: viewController.metrics.metrics[0].descriptor, as: .json)
    }
}

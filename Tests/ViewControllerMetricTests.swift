//
//  ViewControllerMetricTests.swift
//  Tests
//
//  Created by Shams Ahmed on 18/05/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class ViewControllerMetricTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testMetric_init() {
        let metric = UIViewController.Metric()
        
        metric.name = "name"
        metric.`init` = Time.timestamp
        metric.loadView = Time.timestamp
        metric.viewDidLoad = Time.timestamp
        metric.viewWillAppear = Time.timestamp
        metric.viewDidAppear = Time.timestamp
        metric.viewWillLayoutSubviews = Time.timestamp
        metric.viewDidLayoutSubviews = Time.timestamp
        metric.viewWillDisappear = Time.timestamp
        metric.viewDidDisappear = Time.timestamp

        XCTAssertNotNil(metric.description)
        XCTAssertNotNil(metric.viewRenderingLatency)
        XCTAssertNotNil(metric.initTimeInterval)
    }
    
    func testMetric_initWithCoder() {
        let metric = UIViewController.Metric()
        
        metric.name = "name"
        metric.initWithCoder = Time.timestamp
        metric.loadView = Time.timestamp
        metric.viewDidLoad = Time.timestamp
        metric.viewWillAppear = Time.timestamp
        metric.viewDidAppear = Time.timestamp
        metric.viewWillLayoutSubviews = Time.timestamp
        metric.viewDidLayoutSubviews = Time.timestamp
        metric.viewWillDisappear = Time.timestamp
        metric.viewDidDisappear = Time.timestamp

        XCTAssertNotNil(metric.description)
        XCTAssertNotNil(metric.viewRenderingLatency)
        XCTAssertNotNil(metric.initTimeInterval)
    }
    
    func testMetric_initWithNib() {
        let metric = UIViewController.Metric()
        
        metric.name = "name"
        metric.initWithNib = Time.timestamp
        metric.loadView = Time.timestamp
        metric.viewDidLoad = Time.timestamp
        metric.viewWillAppear = Time.timestamp
        metric.viewDidAppear = Time.timestamp
        metric.viewWillLayoutSubviews = Time.timestamp
        metric.viewDidLayoutSubviews = Time.timestamp
        metric.viewWillDisappear = Time.timestamp
        metric.viewDidDisappear = Time.timestamp

        XCTAssertNotNil(metric.description)
        XCTAssertNotNil(metric.viewRenderingLatency)
        XCTAssertNotNil(metric.initTimeInterval)
    }
    
    func testMetric_awakeFromNib() {
        let metric = UIViewController.Metric()
        
        metric.name = "name"
        metric.awakeFromNib = Time.timestamp
        metric.loadView = Time.timestamp
        metric.viewDidLoad = Time.timestamp
        metric.viewWillAppear = Time.timestamp
        metric.viewDidAppear = Time.timestamp
        metric.viewWillLayoutSubviews = Time.timestamp
        metric.viewDidLayoutSubviews = Time.timestamp
        metric.didReceiveMemoryWarning = Time.timestamp
        metric.viewWillDisappear = Time.timestamp
        metric.viewDidDisappear = Time.timestamp

        XCTAssertNotNil(metric.description)
        XCTAssertNotNil(metric.viewRenderingLatency)
        XCTAssertNotNil(metric.initTimeInterval)
    }
}

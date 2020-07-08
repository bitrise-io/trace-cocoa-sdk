//
//  DataTaskFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class DataTaskFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let dataTask: DataTaskFormatter = {
        let url = URL(string: "https://bitrise.io")!
        let session = URLSession(
            configuration: .ephemeral,
            delegate: nil,
            delegateQueue: nil
        )
        let task = session.dataTask(with: url) { _, _, _ in }
        let formatter = DataTaskFormatter(task)
        
        return formatter
    }()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(dataTask)
        XCTAssertNotNil(dataTask.data)
        XCTAssertNotNil(dataTask.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = dataTask.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        XCTAssertNotNil(dataTask.details)
        
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    func testReadMetrics_readOne() {
        let metric = dataTask.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.appRequestTask)
        
        XCTAssertEqual(metric.timeseries.count, 1)
        XCTAssertNotNil(dataTask.details)
    }
    
    func testReadMetrics_readPoints() {
        let points = dataTask.metrics.metrics.first!.timeseries[0].points
        let point = dataTask.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }
    
    func testReadMetrics_readValues() {
        let values = dataTask.metrics.metrics.first!.timeseries[0].values
        let value = dataTask.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 2)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        let metric = dataTask.metrics.metrics[0]
        
        XCTAssertEqual(dataTask.metrics.metrics.count, 1)
        assertSnapshot(matching: metric.descriptor, as: .json)
    }
}

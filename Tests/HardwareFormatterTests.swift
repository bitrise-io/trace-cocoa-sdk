//
//  HardwareFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class HardwareFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let hardware: HardwareFormatter = {
        let cpu = CPU()
        let memory = Memory()
        let connectivity = Connectivity()
        let formatter = HardwareFormatter(cpu: cpu, memory: memory, connectivity: connectivity)
        
        return formatter
    }()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(hardware)
        XCTAssertNotNil(hardware.data)
        XCTAssertNotNil(hardware.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = hardware.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        XCTAssertNotNil(hardware.details)
        
        XCTAssertEqual(metrics.metrics.count, 4)
    }
    
    func testReadMetrics_readOne() {
        let metric = hardware.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.systemCpuPct)
        
        XCTAssertEqual(metric.timeseries.count, 4)
        XCTAssertNotNil(hardware.details)
    }
    
    func testReadMetrics_readPoints() {
        let points = hardware.metrics.metrics.first!.timeseries[0].points
        let point = hardware.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }
    
    func testReadMetrics_readValues() {
        let values = hardware.metrics.metrics.first!.timeseries[0].values
        let value = hardware.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 1)
        XCTAssertTrue(value.hasValue)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: hardware.metrics.metrics[0].descriptor, as: .json)
    }
}

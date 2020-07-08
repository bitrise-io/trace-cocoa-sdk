//
//  MetricTests.swift
//  Tests
//
//  Created by Shams Ahmed on 17/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class MetricTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testMetric_createJSON() {
        let lists: [Metric.Timeseries.Value] = [
            Metric.Timeseries.Value("1")
        ]
        let timeseries = Metric.Timeseries(lists, points: [.point(seconds: 1, nanos: 1, value: 1)])
        let descriptor = Metric.Descriptor(
            name: .appCrashTotal,
            description: "description",
            unit: .string,
            type: .int64,
            keys: [Metric.Descriptor.Key("myKey", description: "myKey")]
        )
        let model = Metric(descriptor: descriptor, timeseries: [timeseries])
        
        XCTAssertNotNil(model)
        XCTAssertNotNil(lists)
        XCTAssertNotNil(timeseries)
        XCTAssertNotNil(descriptor)
        XCTAssertNotNil(model.timeseries)
        XCTAssertNotNil(model.descriptor)
        XCTAssertNotNil(timeseries.values)
        XCTAssertNotNil(descriptor.keys)
        XCTAssertEqual(timeseries.values.count, 1)
        XCTAssertEqual(descriptor.keys.count, 1)
        
        let json = try? model.json()
        let jsonString = model.jsonString()
        
        XCTAssertNotNil(json)
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString?.contains("timeseries") == true)
        XCTAssertTrue(jsonString?.contains("metric_descriptor") == true)
    }
    
    func testMetric_matchesJSON() {
        let lists: [Metric.Timeseries.Value] = [
            Metric.Timeseries.Value("1")
        ]
        let timeseries = Metric.Timeseries(lists, points: [.point(seconds: 1, nanos: 1, value: 1)])
        let descriptor = Metric.Descriptor(
            name: .appCrashTotal,
            description: "description",
            unit: .string,
            type: .int64,
            keys: [Metric.Descriptor.Key("myKey", description: "myKey")]
        )
        let model = Metric(descriptor: descriptor, timeseries: [timeseries])
       
        assertSnapshot(matching: model, as: .json)
    }
    
    func testMetric_mulipleKeys_matchesJSON() {
        let lists: [Metric.Timeseries.Value] = [
            Metric.Timeseries.Value("1"),
            Metric.Timeseries.Value("two"),
            Metric.Timeseries.Value("three"),
            Metric.Timeseries.Value("4")
        ]
        let timeseries = Metric.Timeseries(lists, points: [.point(seconds: 1, nanos: 1, value: 1)])
        let descriptor = Metric.Descriptor(
            name: .systemCpuPct,
            description: "description",
            unit: .string,
            type: .int64,
            keys: [
                Metric.Descriptor.Key("myKey", description: "myKey"),
                Metric.Descriptor.Key("myKey1", description: "myKey1"),
                Metric.Descriptor.Key("myKey2", description: "myKey2"),
                Metric.Descriptor.Key("myKey3", description: "myKey3")
            ]
        )
        let model = Metric(descriptor: descriptor, timeseries: [timeseries])
        
        assertSnapshot(matching: model, as: .json)
        
        XCTAssertEqual(model.timeseries[0].values.count, model.descriptor.keys.count)
    }
}

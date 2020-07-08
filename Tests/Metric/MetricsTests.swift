//
//  MetricsTests.swift
//  Tests
//
//  Created by Shams Ahmed on 17/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class MetricsTests: XCTestCase {
    
    // MARK: - Model
    
    class Mock: Metricable {
        
        // MARK: - Property
        
        var metrics: Metrics = {
            let descriptor = Metric.Descriptor(
                name: .appRequestTask,
                description: "",
                unit: .bytes,
                type: .cumulativeDistribution,
                keys: []
            )
            let timeseries = Metric.Timeseries(.none, points: [])
            let metric = Metric(descriptor: descriptor, timeseries: timeseries)
            let metrics = Metrics([metric])
            
            return metrics
        }()
    }
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testMetrics_createJSON() {
        let lists: [Metric.Timeseries.Value] = [
            Metric.Timeseries.Value("1")
        ]
        let timeseries = Metric.Timeseries(lists, points: [.point(seconds: 1, nanos: 1, value: 1)])
        let descriptor = Metric.Descriptor(
            name: .processCpuPct,
            description: "description",
            unit: .one,
            type: .int64,
            keys: [Metric.Descriptor.Key("myKey", description: "myKey")]
        )
        let metric1 = Metric(descriptor: descriptor, timeseries: [timeseries])
        let model = Metrics([metric1])
        let json = try? model.json()
        let jsonString = model.jsonString()
        
        XCTAssertNotNil(json)
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString?.contains("timeseries") == true)
        XCTAssertTrue(jsonString?.contains("metric_descriptor") == true)
    }
    
    func testMetrics_matchesJSON() {
        let lists: [Metric.Timeseries.Value] = [
            Metric.Timeseries.Value("1")
        ]
        let timeseries = Metric.Timeseries(lists, points: [.point(seconds: 1, nanos: 1, value: 1)])
        let descriptor = Metric.Descriptor(
            name: .viewFrameRate,
            description: "description",
            unit: .percent,
            type: .int64,
            keys: [Metric.Descriptor.Key("myKey", description: "myKey")]
        )
        let metric1 = Metric(descriptor: descriptor, timeseries: [timeseries])
        let model = Metrics([metric1])

        assertSnapshot(matching: model, as: .json)
    }

    func testMetric_mulipleKeys_matchesJSON() {
        let lists: [Metric.Timeseries.Value] = [
            Metric.Timeseries.Value("1")
        ]
        let timeseries = Metric.Timeseries(lists, points: [.point(seconds: 1, nanos: 1, value: 1)])
        let descriptor = Metric.Descriptor(
            name: .appRequestSizeBytes,
            description: "description",
            unit: .one,
            type: .int64,
            keys: [Metric.Descriptor.Key("myKey", description: "myKey")]
        )
        let descriptor1 = Metric.Descriptor(
            name: .appPrerequestTotal,
            description: "description1",
            unit: .percent,
            type: .int64,
            keys: [Metric.Descriptor.Key("myKey1", description: "myKey1")]
        )
        let descriptor2 = Metric.Descriptor(
            name: .appErrorTotal,
            description: "description2",
            unit: .one,
            type: .int64,
            keys: [.key("myKey2", description: "myKey2")]
        )
        let metric1 = Metric(descriptor: descriptor, timeseries: [timeseries])
        let metric2 = Metric(descriptor: descriptor1, timeseries: [timeseries])
        let metric3 = Metric(descriptor: descriptor2, timeseries: [timeseries])
        let model = Metrics([metric1, metric2, metric3])
        
        assertSnapshot(matching: model, as: .json)
    }
    
    func testMetricables() {
        let mock = Mock()
        let metrics = Metrics([mock], resource: nil)
        
        XCTAssertNotNil(metrics)
        XCTAssertNotNil(mock.metrics)
        XCTAssertEqual(metrics.metrics.count, 1)
    }
    
    func testIsCollatable() {
        let appCrashTotal = Metric.Descriptor.Name.appCrashTotal.isCollatable
        let appSessionMilliseconds = Metric.Descriptor.Name.appSessionMilliseconds.isCollatable
        
        XCTAssertTrue(appCrashTotal)
        XCTAssertFalse(appSessionMilliseconds)
    }
    
    func testIsCountable() {
        let test1 = Metric.Descriptor.Name.appCrashTotal.isCountable
        let test2 = Metric.Descriptor.Name.appRequestSizeBytes.isCountable
        
        XCTAssertTrue(test1)
        XCTAssertFalse(test2)
    }
    
    func testMetrics_matchesJSON_withAttributes() {
        let lists: [Metric.Timeseries.Value] = [
            Metric.Timeseries.Value("1")
        ]
        let timeseries = Metric.Timeseries(lists, points: [.point(seconds: 1, nanos: 1, value: 1)])
        let descriptor = Metric.Descriptor(
            name: .viewFrameRate,
            description: "description",
            unit: .percent,
            type: .int64,
            keys: [Metric.Descriptor.Key("myKey", description: "myKey")]
        )
        let attributes = ["test1": "test2"]
        let metric1 = Metric(descriptor: descriptor, timeseries: [timeseries])
        let model = Metrics([metric1], attributes: attributes)

        assertSnapshot(matching: model, as: .json)
    }
}

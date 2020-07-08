//
//  TimeseriesTests.swift
//  Trace
//
//  Created by Shams Ahmed on 16/06/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class TimeseriesTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testTimeseries_createJSON() {
        let lists: [Metric.Timeseries.Value] = [
            Metric.Timeseries.Value("1"),
            Metric.Timeseries.Value("2"),
            Metric.Timeseries.Value("3"),
            Metric.Timeseries.Value("string1"),
            Metric.Timeseries.Value("string2"),
            Metric.Timeseries.Value("string3")
        ]
        let model = Metric.Timeseries(lists, points: [.point(seconds: 1, nanos: 1, value: 1)])
        
        XCTAssertNotNil(lists)
        XCTAssertNotNil(model)
        XCTAssertNotNil(model.values)
        XCTAssertEqual(model.values.count, 6)
        
        let json = try? model.json()
        let jsonString = model.jsonString()
        
        XCTAssertNotNil(json)
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString?.contains("string1") == true)
    }
    
    func testTimeseries_matchesJSON() {
        let lists: [Metric.Timeseries.Value] = [
            Metric.Timeseries.Value("1"),
            Metric.Timeseries.Value("2"),
            Metric.Timeseries.Value("3"),
            Metric.Timeseries.Value("string1"),
            Metric.Timeseries.Value("string2"),
            Metric.Timeseries.Value("string3")
        ]
        let model = Metric.Timeseries(lists, points: [.point(seconds: 1, nanos: 1, value: 1)])
        
        assertSnapshot(matching: model, as: .json)
    }
}

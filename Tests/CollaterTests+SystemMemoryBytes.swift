//
//  CollaterTests+SystemMemoryBytes.swift
//  Tests
//
//  Created by Shams Ahmed on 01/07/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
@testable import Trace
import XCTest

extension CollaterTests {
    
    // MARK: - Tests
    
    func testSystemMemoryBytes_match() {
        let timeseries: [Metric.Timeseries] = decode(json: "systemMemoryBytes_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 12)
        XCTAssertEqual(collated.count, 6)
        XCTAssertGreaterThan(timeseries.count, collated.count)
    }
    
    func testSystemMemoryBytes_no_match() {
        let timeseries: [Metric.Timeseries] = decode(json: "systemMemoryBytes_no_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 6)
        XCTAssertEqual(collated.count, 6)
        XCTAssertEqual(timeseries.count, collated.count)
    }
}

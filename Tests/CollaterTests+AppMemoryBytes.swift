//
//  CollaterTests+AppMemoryBytes.swift
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
    
    func testAppMemoryBytes_match() {
        let timeseries: [Metric.Timeseries] = decode(json: "appMemoryBytes_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 6)
        XCTAssertEqual(collated.count, 2)
        XCTAssertGreaterThan(timeseries.count, collated.count)
    }
    
    func testAppMemoryBytes_no_match() {
        let timeseries: [Metric.Timeseries] = decode(json: "appMemoryBytes_no_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 2)
        XCTAssertEqual(collated.count, 2)
        XCTAssertEqual(timeseries.count, collated.count)
    }
}

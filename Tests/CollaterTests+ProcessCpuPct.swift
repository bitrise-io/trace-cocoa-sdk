//
//  CollaterTests+ProcessCpuPct.swift
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
    
    func testProcessCpuPct_match() {
        let timeseries: [Metric.Timeseries] = decode(json: "processCpuPct_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 3)
        XCTAssertEqual(collated.count, 1)
        XCTAssertGreaterThan(timeseries.count, collated.count)
    }
    
    func testProcessCpuPct_no_match() {
        let timeseries: [Metric.Timeseries] = decode(json: "processCpuPct_no_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 1)
        XCTAssertEqual(collated.count, 1)
        XCTAssertEqual(timeseries.count, collated.count)
    }
}

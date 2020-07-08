//
//  CollaterTests+SystemCpuPct.swift
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
    
    func testSystemCpuPct_match() {
        let timeseries: [Metric.Timeseries] = decode(json: "systemCpuPct_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 12)
        XCTAssertEqual(collated.count, 4)
        XCTAssertGreaterThan(timeseries.count, collated.count)
    }
    
    func testsystemCpuPct_no_match() {
        let timeseries: [Metric.Timeseries] = decode(json: "systemCpuPct_no_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 4)
        XCTAssertEqual(collated.count, 4)
        XCTAssertEqual(timeseries.count, collated.count)
    }
}

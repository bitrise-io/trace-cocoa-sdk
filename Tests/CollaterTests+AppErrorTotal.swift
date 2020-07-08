//
//  CollaterTests+AppErrorTotal.swift
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
    
    func testAppErrorTotal_noMatches() {
        let timeseries: [Metric.Timeseries] = decode(json: "appErrorTotal_no_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 2)
        XCTAssertEqual(collated.count, 2)
        XCTAssertEqual(timeseries.count, collated.count)
    }
    
    func testAppErrorTotal_matches() {
        let timeseries: [Metric.Timeseries] = decode(json: "appErrorTotal_match")
        let collated = Metric.Collater(timeseries).collate()
        
        XCTAssertNotNil(collated)
        XCTAssertEqual(timeseries.count, 5)
        XCTAssertEqual(collated.count, 4)
        XCTAssertGreaterThan(timeseries.count, collated.count)
    }
}

//
//  FilterPipelineTests.swift
//  Tests
//
//  Created by Shams Ahmed on 18/02/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class FilterPipelineTests: XCTestCase {
    
    // MARK: - Property
    
    let filter = FilterPipeline.with(filters: [FilterStringToData()])
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testCount() {
        XCTAssertEqual(filter.filters.count, 1)
    }
    
    func testReports() {
        let mocks = [Data()]
        let processExpectation = expectation(description: "process report")
        var newReports = [Any]()
        
        filter.filterReports(mocks) { (reports, result, error) in
            processExpectation.fulfill()
            
            newReports.append(reports ?? [])
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(newReports.count, 1)
    }
}

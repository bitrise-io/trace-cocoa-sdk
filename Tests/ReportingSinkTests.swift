//
//  ReportingSinkTests.swift
//  Tests
//
//  Created by Shams Ahmed on 18/02/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class ReportingSinkTests: XCTestCase {
    
    // MARK: - Property
    
    let sink = ReportingSink(with: "path")
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testFilters() {
        guard let filter = sink.filter as? FilterPipeline else {
            return XCTFail("wrong filter type")
        }
        
        XCTAssertEqual(filter.filters.count, 3)
    }
    
    func testsMockReports() {
        let mocks = [Data()]
        
        let processExpectation = expectation(description: "process report")
        var newReports = [Any]()
        
        sink.filterReports(mocks) { (reports, result, error) in
            processExpectation.fulfill()
            
            newReports.append(reports ?? [])
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(newReports.count, 1)
    }
}

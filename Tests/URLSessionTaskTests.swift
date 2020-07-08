//
//  URLSessionTaskTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class URLSessionTaskTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testTaskHasNotGotDates() {
        let task = URLSessionTask()
        
        XCTAssertNil(task.startDate)
        XCTAssertNil(task.endDate)
    }
    
    func testTaskHasDates() {
        let task = URLSessionTask()
        task.startDate = .init(seconds: 1, nanos: 1, timeInterval: 1)
        task.endDate = .init(seconds: 10, nanos: 10, timeInterval: 10)
        
        XCTAssertNotNil(task.startDate)
        XCTAssertNotNil(task.endDate)
        XCTAssertEqual(task.startDate?.seconds, 1)
        XCTAssertEqual(task.endDate?.seconds, 10)
    }
}

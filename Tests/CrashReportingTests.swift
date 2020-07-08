//
//  CrashReportingTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/10/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class CrashReportingTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testReporting() {
        let result = CrashReporting.observe()
        
        XCTAssertTrue(result)
        XCTAssertNotNil(NSGetUncaughtExceptionHandler())
    }
}

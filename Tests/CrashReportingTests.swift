//
//  CrashReportingTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
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
    
    func testReporting_report() throws {
        try XCTSkipIf(true, "Crashes the test runner")
        
        let result = CrashReporting.observe()
        let exceptionHandler = NSGetUncaughtExceptionHandler()
        let exception = NSException(name: NSExceptionName("test"), reason: "test", userInfo: nil)
        
        XCTAssertThrowsError(exceptionHandler?(exception))
        
        XCTAssertTrue(result)
    }
    
    func testReporting_terminate() throws {
        try XCTSkipIf(true, "Crashes the test runner")
        
        CrashReporting.terminate()
        
        XCTAssertNil(NSGetUncaughtExceptionHandler())
    }
    
    func testReporting_process() {
        CrashReporting.process(with: CrashReporting.Report(type: .signal, name: "tedt", reason: "test", callStack: "callStack.."))
    }
}

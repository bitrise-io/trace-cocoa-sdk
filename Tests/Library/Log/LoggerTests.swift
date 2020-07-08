//
//  LoggerTests.swift
//  Tests
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class LoggerTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        Trace.configuration.logs = true
    }
    
    // MARK: - Tests
    
    func testCanPrint_string() {
        Trace.configuration.logs = true
        
        XCTAssertTrue(Logger.print(.application, "test"))
    }
    
    func testCanPrint_object() {
        Trace.configuration.logs = true
        
        XCTAssertTrue(Logger.print(.application, ["1", "2", "3"]))
    }
    
    func testCanotPrint_string() {
        Trace.configuration.logs = false
        
        XCTAssertFalse(Logger.print(.application, "test"))
    }
    
    func testCannotPrint_object() {
        Trace.configuration.logs = false
        
        XCTAssertFalse(Logger.print(.application, ["1", "2", "3"]))
    }
}

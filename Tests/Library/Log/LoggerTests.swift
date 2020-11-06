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
        
    }
    
    // MARK: - Tests
    
    func testDebug() {
        Trace.configuration.log = .debug
        
        XCTAssertEqual(Trace.configuration.log, .debug)
    }
    
    func testDefault() {
        Trace.configuration.log = .default
        
        XCTAssertEqual(Trace.configuration.log, .default)
    }
    
    func testWarning() {
        Trace.configuration.log = .warning
        
        XCTAssertEqual(Trace.configuration.log, .warning)
    }
    
    func testError() {
        Trace.configuration.log = .error
        
        XCTAssertEqual(Trace.configuration.log, .error)
    }
    
    func testCanPrint_string() {
        Trace.configuration.log = .default
        
        XCTAssertTrue(Logger.default(.application, "test"))
    }
    
    func testCanPrint_object() {
        Trace.configuration.log = .default
        
        XCTAssertTrue(Logger.default(.application, ["1", "2", "3"]))
    }
    
    func testCannotPrint_string() {
        Trace.configuration.log = .warning
        
        XCTAssertEqual(Trace.configuration.log, .warning)
        XCTAssertFalse(Logger.debug(.application, "test"))
    }
    
    func testCannotPrint_object() {
        Trace.configuration.log = .error
        
        XCTAssertEqual(Trace.configuration.log, .error)
        XCTAssertFalse(Logger.debug(.application, ["1", "2", "3"]))
    }
}

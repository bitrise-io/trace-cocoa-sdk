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
    
    func testLogLevel_equal() {
        XCTAssertEqual(LoggerLevel.debug, LoggerLevel.debug)
        XCTAssertEqual(LoggerLevel.default, LoggerLevel.default)
        XCTAssertEqual(LoggerLevel.warning, LoggerLevel.warning)
        XCTAssertEqual(LoggerLevel.error, LoggerLevel.error)
    }
    
    func testLogLevel_not_equal() {
        XCTAssertNotEqual(LoggerLevel.debug, LoggerLevel.error)
        XCTAssertNotEqual(LoggerLevel.default, LoggerLevel.error)
        XCTAssertNotEqual(LoggerLevel.warning, LoggerLevel.error)
        XCTAssertNotEqual(LoggerLevel.error, LoggerLevel.debug)
    }
    
    func testLogLevel_greaterThan() {
        XCTAssertGreaterThan(LoggerLevel.default, LoggerLevel.debug)
        XCTAssertGreaterThan(LoggerLevel.warning, LoggerLevel.default)
        XCTAssertGreaterThan(LoggerLevel.error, LoggerLevel.warning)
    }
    
    func testLogLevel_lessThan() {
        XCTAssertLessThan(LoggerLevel.debug, LoggerLevel.default)
        XCTAssertLessThan(LoggerLevel.default, LoggerLevel.warning)
        XCTAssertLessThan(LoggerLevel.warning, LoggerLevel.error)
    }
}

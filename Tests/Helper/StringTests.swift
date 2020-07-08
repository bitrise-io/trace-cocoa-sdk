//
//  StringTests.swift
//  Tests
//
//  Created by Shams Ahmed on 16/10/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation

import XCTest
@testable import Trace

final class StringTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testToHex() {
        let string = "hello world!"
        let hex = string.toHex
        
        XCTAssertNotNil(hex)
        XCTAssertEqual(hex, "68656c6c6f20776f726c6421")
    }
    
    func testFromHex() {
        let hex = "68656c6c6f20776f726c6421"
        let string = hex.fromHex
        
        XCTAssertNotNil(string)
        XCTAssertEqual(string, "hello world!")
    }
    
    func testBackAndForth() {
        let string = "hello world!"
        let hex = string.toHex
        let convertedString = hex.fromHex
        
        XCTAssertNotNil(hex)
        XCTAssertEqual(hex, "68656c6c6f20776f726c6421")
        XCTAssertNotNil(convertedString)
        XCTAssertEqual(convertedString, string)
    }
    
    func testBackAndForthUUID16() {
        let string = "0123456789ABCDEF"
        let hex = string.toHex
        let convertedString = hex.fromHex
        
        XCTAssertEqual(string.count, 16)
        XCTAssertNotNil(hex)
        XCTAssertEqual(hex.count, 32)
        XCTAssertEqual(hex, "30313233343536373839414243444546")
        XCTAssertNotNil(convertedString)
        XCTAssertEqual(convertedString, string)
    }
    
    func testBackAndForthUUID8() {
        let string = "01234567"
        let hex = string.toHex
        let convertedString = hex.fromHex
        
        XCTAssertEqual(string.count, 8)
        XCTAssertNotNil(hex)
        XCTAssertEqual(hex.count, 16)
        XCTAssertEqual(hex, "3031323334353637")
        XCTAssertNotNil(convertedString)
        XCTAssertEqual(convertedString, string)
    }
}

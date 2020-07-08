//
//  UUIDTests.swift
//  Tests
//
//  Created by Shams Ahmed on 11/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class UUIDTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testLetters_8() {
        let letters = UUID.random(8)
        
        XCTAssertNotNil(letters)
        XCTAssertEqual(letters.count, 8)
        XCTAssertNotEqual(letters, "abcdefgh")
    }
    
    func testLetters_16() {
        let letters = UUID.random(16)
        
        XCTAssertNotNil(letters)
        XCTAssertEqual(letters.count, 16)
    }
    
    func testLetters_32() {
        let letters = UUID.random(32)
        
        XCTAssertNotNil(letters)
        XCTAssertEqual(letters.count, 32)
    }
    
    func testLetters_64() {
        let letters = UUID.random(64)
        
        XCTAssertNotNil(letters)
        XCTAssertEqual(letters.count, 64)
    }
    
    func testCompare_8() {
        let letters1 = UUID.random(8)
        let letters2 = UUID.random(8)
        
        XCTAssertNotEqual(letters1, letters2)
    }
    
    func testCompare_16() {
        let letters1 = UUID.random(16)
        let letters2 = UUID.random(16)
        
        XCTAssertNotEqual(letters1, letters2)
    }
    
    func testCompare_32() {
        let letters1 = UUID.random(32)
        let letters2 = UUID.random(32)
        
        XCTAssertNotEqual(letters1, letters2)
    }
    
    func testCompare_64() {
        let letters1 = UUID.random(64)
        let letters2 = UUID.random(64)
        
        XCTAssertNotEqual(letters1, letters2)
    }
}

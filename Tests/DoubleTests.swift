//
//  DoubleTests.swift
//  Tests
//
//  Created by Shams Ahmed on 24/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class DoubleTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testRandom() {
        let random: Double = .random
        
        XCTAssertNotNil(random)
        XCTAssertGreaterThan(random, 0.0001)
    }
    
    func testSplitAtDecimal() {
        let value = 12.34
        let split = value.splitAtDecimal
        
        XCTAssertEqual(split.integer, 12)
        XCTAssertEqual(split.fractional, 34)
    }
    
    func testSplitAtDecimalLong() {
        let value = 123456.789
        let split = value.splitAtDecimal
        
        XCTAssertEqual(split.integer, 123456)
        XCTAssertEqual(split.fractional, 789)
    }
    
    func testSplitAtDecimal_round() {
        let value = 1.99
        let split = value.splitAtDecimal
        
        XCTAssertEqual(split.integer, 1)
        XCTAssertEqual(split.fractional, 99)
    }
}

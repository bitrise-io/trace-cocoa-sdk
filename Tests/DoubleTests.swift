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
}

//
//  TimeTests.swift
//  Trace
//
//  Created by Shams Ahmed on 12/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class TimeTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testTime() {
        let time = Time.current
        
        XCTAssertNotNil(time)
        XCTAssertNotEqual(time, 0)
    }
    
    func testTimer() {
        let time = Time.time {
            for _ in 0...100 {
                
            }
        }
        
        XCTAssertNotNil(time)
        XCTAssertNotEqual(time, 0)
    }
}

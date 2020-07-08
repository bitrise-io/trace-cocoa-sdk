//
//  MemoryTests.swift
//  Tests
//
//  Created by Shams Ahmed on 23/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class MemoryTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testReadUsage_once() {
        let memory = Memory()
        
        XCTAssertNotNil(memory.applicationUsage)
        XCTAssertNotNil(memory.systemUsage)
        XCTAssertGreaterThan(memory.applicationUsage.total, 1)
        XCTAssertGreaterThan(memory.systemUsage.free, 1)
    }
    
    func testReadUsage_100Times() {
        let memory = Memory()
        
        for _ in 0...100 {
            XCTAssertNotNil(memory.applicationUsage)
            XCTAssertNotNil(memory.systemUsage)
            XCTAssertGreaterThan(memory.applicationUsage.total, 1)
            XCTAssertGreaterThan(memory.systemUsage.free, 1)
        }
    }

    func testReadUsage_100TimesWithNewObject() {
        for _ in 0...100 {
            let memory = Memory()
            
            XCTAssertNotNil(memory.applicationUsage)
            XCTAssertNotNil(memory.systemUsage)
            XCTAssertGreaterThan(memory.applicationUsage.total, 1)
            XCTAssertGreaterThan(memory.systemUsage.free, 1)
        }
    }
}

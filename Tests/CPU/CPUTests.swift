//
//  CPUTests.swift
//  Tests
//
//  Created by Shams Ahmed on 22/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class CPUTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testReadUsage_once() {
        let cpu = CPU()
        
        XCTAssertNotNil(cpu.applicationUsage)
        XCTAssertNotNil(cpu.systemUsage)
        XCTAssertGreaterThan(cpu.physicalCores, 1)
        XCTAssertGreaterThan(cpu.logicalCores, 1)
    }
    
    func testReadUsage_100Times() {
        let cpu = CPU()

        for _ in 0...100 {
            XCTAssertNotNil(cpu.applicationUsage)
            XCTAssertNotNil(cpu.systemUsage)
            XCTAssertGreaterThan(cpu.physicalCores, 1)
            XCTAssertGreaterThan(cpu.logicalCores, 1)
        }
    }

    func testReadUsage_100TimesWithNewObject() {
        for _ in 0...100 {
            let cpu = CPU()

            XCTAssertNotNil(cpu.applicationUsage)
            XCTAssertNotNil(cpu.systemUsage)
            XCTAssertGreaterThan(cpu.physicalCores, 1)
            XCTAssertGreaterThan(cpu.logicalCores, 1)
        }
    }
}

//
//  SwiftOnlyLoadTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class SwiftOnlyLoadTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testSwiftStart() {
        XCTAssertGreaterThan(Trace.currentSession, 0)
    }
    
    func testSwiftStart_next() {
        XCTAssertNil(UIApplication.shared.next)
    }
}

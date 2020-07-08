//
//  ViewFilterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 06/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class ViewFilterTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testBannedClass_true() {
        class NSTest: UIView { }
        
        XCTAssertTrue(NSTest().isBannedClass)
        XCTAssertFalse(NSTest().isInternalClass)
    }
    
    func testBannedClass_false() {
        class Test: UIView { }
        
        XCTAssertFalse(Test().isBannedClass)
        XCTAssertFalse(Test().isInternalClass)
    }
    
    func testInternalClass() {
        class _NSTest: UIView { }
        
        XCTAssertFalse(_NSTest().isBannedClass)
        XCTAssertTrue(_NSTest().isInternalClass)
    }
}

//
//  ViewControllerFilterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 06/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class ViewControllerFilterTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testBannedClass_true() {
        class NSTest: UIViewController { }
        
        XCTAssertTrue(UINavigationController().isBannedClass)
        XCTAssertFalse(UINavigationController().isInternalClass)
    }
    
    func testBannedClass_false() {
        class Test: UIViewController { }
        
        XCTAssertFalse(Test().isBannedClass)
        XCTAssertFalse(Test().isInternalClass)
    }
    
    func testInternalClass() {
        class _NSTest: UIViewController { }
        
        XCTAssertFalse(_NSTest().isBannedClass)
        XCTAssertTrue(_NSTest().isInternalClass)
    }
}

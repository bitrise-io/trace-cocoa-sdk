//
//  JSContextTests.swift
//  Tests
//
//  Created by Shams Ahmed on 18/05/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation
import JavaScriptCore
import XCTest
@testable import Trace

final class JSContextTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        JSContext.bitrise_swizzle_methods()
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testException() {
        JSContext.bitrise_swizzle_methods()
        
        let expectation = XCTestExpectation()
        
        let context = JSContext()
        context?.exceptionHandler = { context, value in
            expectation.fulfill()
        }
        
        context?.evaluateScript("process.exit")
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testException_override() {
        JSContext.bitrise_swizzle_methods()
        
        let expectation = XCTestExpectation()
        
        let context = JSContext()
        context?.exceptionHandler = { context, value in
            expectation.fulfill()
        }
        
        context?.bitrise_exceptionHandler(context, nil)
        
        wait(for: [expectation], timeout: 5)
    }
}

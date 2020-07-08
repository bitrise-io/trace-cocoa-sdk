//
//  RepeaterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 06/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class RepeaterTests: XCTestCase {
    
    // MARK: - Property
    
    var repeater: Repeater?
    
    // MARK: - Setup
    
    override func setUp() {
        if repeater == nil {
            repeater = Repeater(0.5)
        }
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testCallback_resume() {
        let async = expectation(description: "async")
        
        repeater?.state = .resume
        repeater?.handler = { async.fulfill() }
        repeater?.state = .resume
        
        waitForExpectations(timeout: 2, handler: nil)
        
        repeater = nil
    }
    
    func testCallback_suspend() {
        repeater?.state = .suspend
        repeater?.handler = { XCTFail() }
    }
}

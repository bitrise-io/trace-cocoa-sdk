//
//  FPSTests.swift
//  Tests
//
//  Created by Shams Ahmed on 02/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

import XCTest
@testable import Trace

final class FPSTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testFPS() {
        let fps = FPS()
        
        XCTAssertEqual(fps.current.fps, 0.0)
        XCTAssertEqual(fps.current.viewController, "")
    }
    
    func testFPS_noDelay() {
        let fps = FPS()
        fps.delay = -10.0
        
        XCTAssertEqual(fps.current.fps, 0.0)
        XCTAssertEqual(fps.current.viewController, "")
    }
}

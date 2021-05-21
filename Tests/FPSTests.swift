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
    
    func testFPS_sendCADisplayLink() {
        let link = CADisplayLink()
        
        let fps = FPS()
        fps.step(link)
        
        XCTAssertNotNil(fps.current)
    }
    
    func testFPS_process_fails_no_viewcontrollerFound() {
        let fps = FPS()
        let link = CADisplayLink()
        let old = fps.current
        
        fps.lastNotification = 60.0
        fps.step(link)
        
        let new = fps.current
        
        XCTAssertEqual(old.fps, new.fps)
        XCTAssertEqual(old.timestamp.timeInterval, new.timestamp.timeInterval)
        XCTAssertEqual(old.viewController, new.viewController)
    }
}

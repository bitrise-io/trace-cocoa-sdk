//
//  LifecycleUITests.swift
//  iOSDemoUITests
//
//  Created by Mukund Agarwal on 12/05/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import XCTest

class LifecycleUITests: XCTestCase {
    
    // MARK: - Property
    
    let app = XCUIApplication()
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        app.launch()
    }
    
    // MARK: - Tests
    
    func testForegroundToBackground() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            moveAppToForeground()
            _ = app.wait(for: .runningForeground, timeout: 5)
            
            moveAppToBackground()
            _ = app.wait(for: .runningBackground, timeout: 5)
        }
    }
    
    func testBackgroundToForeground() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            moveAppToForeground()
            moveAppToBackground()
            _ = app.wait(for: .runningBackground, timeout: 5)
            
            moveAppToForeground()
            _ = app.wait(for: .runningForeground, timeout: 5)
        }
    }
    
    func testMultipleForegroundToBackground() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            _ = app.wait(for: .runningForeground, timeout: 5)
            moveAppToBackground()
            moveAppToForeground()
            moveAppToBackground()
            moveAppToForeground()
            moveAppToBackground()
            moveAppToForeground()
            moveAppToBackground()
            moveAppToForeground()
            _ = app.wait(for: .runningForeground, timeout: 5)
        }
    }
    
    func testLockScreen() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            _ = app.wait(for: .runningForeground, timeout: 5)
            XCUIDevice.shared.perform(NSSelectorFromString("pressLockButton"))
            _ = app.wait(for: .runningForeground, timeout: 5)
        }
    }
    
    // MARK: - Private methods
    
    private func moveAppToBackground() {
        XCUIDevice.shared.press(.home)
    }
    
    private func moveAppToForeground() {
        app.activate()
    }
    
}

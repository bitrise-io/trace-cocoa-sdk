//
//  CrashUITests.swift
//  iOSDemoUITests
//
//  Created by Mukund Agarwal on 13/05/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import XCTest

class CrashUITests: XCTestCase {
    
    // MARK: - Property
    
    let app = XCUIApplication()
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        app.launch()
    }
    
    // MARK: - Tests
    
    func testCrashAndRestart_crash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.app.terminate()
        }
        
        app.tables.staticTexts["Crash 💥"].tap()
        
        if app.wait(for: .notRunning, timeout: 1) {
            app.terminate()
        }
        
        let result = app.wait(for: .notRunning, timeout: 5)
        XCTAssertTrue(result)
    }
    
    func testCrashAndRestart_validation() {
        if app.state == .notRunning {
            app.launch()
        }
        
        if !app.wait(for: .runningForeground, timeout: 3) {
            app.launch()
        }
        
        sleep(10)
        
        let result = app.wait(for: .runningForeground, timeout: 5)
        XCTAssertTrue(result)
    }
    
}

//
//  ControlUITests.swift
//  iOSDemoUITests
//
//  Created by Mukund Agarwal on 11/05/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import XCTest

class ControlUITests: XCTestCase {
    
    // MARK: - Property
    
    let app = XCUIApplication()
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        app.launch()
    }
    
    // MARK: - Tests
    
    func testControlTab() {
        tapTestFlow()
    }
    
    func testControlTabPerformance() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            tapTestFlow()
        }
    }
    
    // MARK: - Private methods
    
    private func tapTestFlow() {
        tapControl()
        tapIncrement()
        tapButton()
        moveSliderToLeft()
        tapSecondButton()
    }
    
    private func tapControl() {
        if app.tables.staticTexts["Control"].exists {
            app.tables.staticTexts["Control"].tap()
        }
    }
    
    private func tapIncrement() {
        if app.steppers.buttons["Increment"].exists {
            app.steppers.buttons["Increment"].tap()
        }
    }
    
    private func tapButton() {
        if app.staticTexts["Button"].exists {
            app.staticTexts["Button"].tap()
        }
    }
    
    private func moveSliderToLeft() {
        if app.sliders["50%"].exists {
            app.sliders["50%"].swipeLeft()
        }
    }
    
    private func tapSecondButton() {
        if app.buttons["Second"].exists {
            app.buttons["Second"].tap()
        }
    }
    
}

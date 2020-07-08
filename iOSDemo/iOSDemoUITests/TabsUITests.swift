//
//  TabsUITests.swift
//  iOSDemoUITests
//
//  Created by Mukund Agarwal on 11/05/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import XCTest

class TabsUITests: XCTestCase {
    
    // MARK: - Property
    
    let app = XCUIApplication()
    
    // MARK: - Setup

    override func setUp() {
        super.setUp()
        app.launch()
    }
    
    // MARK: - Tests
    
    func testFirstTab() {
        tapTabs()
        app.staticTexts["First"].tap()
    }
    
    func testSecondTab() {
        tapTabs()
        tapTab(title: "Second")
        app.staticTexts["Second"].tap()
    }
    
    func testBackAndForth() {
        tapTabs()
        tapTab(title: "Second")
        tapTab(title: "First")
        tapTab(title: "Second")
        tapTab(title: "First")
        tapTab(title: "Second")
        tapTab(title: "First")
        app.staticTexts["First"].tap()
    }
    
    func testTabsPerformance() {
         measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
             tapTabs()
             tapTab(title: "Second")
             tapTab(title: "First")
             tapTab(title: "Second")
             tapTab(title: "First")
        }
    }
    
    // MARK: - Private methods

    private func tapTabs() {
        if app.tables.staticTexts["Tabs"].exists {
            app.tables.staticTexts["Tabs"].tap()
        }
    }
    
    private func tapTab(title: String) {
        if app.tabBars.buttons[title].exists {
            app.tabBars.buttons[title].tap()
        }
    }
}

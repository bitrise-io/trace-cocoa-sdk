//
//  NetworkUITests.swift
//  Tests
//
//  Created by Mukund Agarwal on 06/05/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import XCTest

class NetworkUITests: XCTestCase {
    
    // MARK: - Property
    
    let app = XCUIApplication()
    
    // MARK: - Setup

    override func setUp() {
        super.setUp()
        app.launch()
    }
    
    // MARK: - Tests
    
    func testNetworking() {
        goToNetworkingScreen(wait: 30)
        goBackToMainScreen()
        goToNetworkingScreen(wait: 2)
        goBackToMainScreen()
        goToNetworkingScreen(wait: 2)

        XCTAssertEqual(app.state, XCUIApplication.State.runningForeground)
    }
    
    func testNetworkingPerformance() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            goToNetworkingScreen(wait: 10)
            goBackToMainScreen()
            goToNetworkingScreen(wait: 2)
            goBackToMainScreen()
        }
    }
    
    // MARK: - Private methods

    private func goToNetworkingScreen(wait delay: UInt32) {
        if app.tables.staticTexts["Network"].exists {
            app.tables.staticTexts["Network"].tap()
            sleep(delay)
        }
    }
    
    private func goBackToMainScreen() {
        if app.navigationBars["Network"].buttons["Main"].exists {
            app.navigationBars["Network"].buttons["Main"].tap()
        }
    }
}

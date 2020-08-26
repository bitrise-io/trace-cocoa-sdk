//
//  iOSDemoUITests.swift
//  iOSDemoUITests
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import XCTest

final class iOSDemoUITests: XCTestCase {

    // MARK: - Property
    
    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {
        
    }
    
    // MARK: - Tests

    func testLaunch() {
        let app = XCUIApplication()
        app.launch()
        
        sleep(10)
        
        let result = app.wait(for: .runningForeground, timeout: 5)
        
        XCTAssertTrue(result)
    }
    
    func testLaunchEnvironment() {
        let app = XCUIApplication()
        app.launchEnvironment = [
            BitriseConfiguration.CodingKeys.token.rawValue: "my_token",
            BitriseConfiguration.CodingKeys.environment.rawValue: "https://bitrise.io"
        ]
        app.launch()
        
        let result = app.wait(for: .runningForeground, timeout: 5)
        
        XCTAssertTrue(result)
    }
    
    func testLaunchEnvironment_token() {
        let app = XCUIApplication()
        app.launchEnvironment = [
            BitriseConfiguration.CodingKeys.token.rawValue: "my_token"
        ]
        app.launch()
        
        let result = app.wait(for: .runningForeground, timeout: 5)
        
        XCTAssertTrue(result)
    }
    
    func testLaunchEnvironment_environment() {
        let app = XCUIApplication()
        app.launchEnvironment = [
            BitriseConfiguration.CodingKeys.environment.rawValue: "https://bitrise.io"
        ] // will not set it as there isn't any token 
        app.launch()
        
        let result = app.wait(for: .runningForeground, timeout: 5)
        
        XCTAssertTrue(result)
    }
}

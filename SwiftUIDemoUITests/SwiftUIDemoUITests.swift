//
//  SwiftUIDemoUITests.swift
//  SwiftUIDemoUITests
//
//  Created by Shams Ahmed on 24/08/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import XCTest

class SwiftUIDemoUITests: XCTestCase {
    
    // MARK: - Setup

    override func setUpWithError() throws {
        super.setUpWithError()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        super.tearDownWithError()
    }
    
    // MARK: - Tests

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                let app = XCUIApplication()
                app.launch()
            }
        }
    }
}

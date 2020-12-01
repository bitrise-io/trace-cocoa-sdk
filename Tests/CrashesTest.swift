//
//  CrashesTest.swift
//  Tests
//
//  Created by Shams Ahmed on 13/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class CrashesTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testCrashes() {
        let report = Data()
        let crash = Crash(
            id: "123",
            timestamp: "2020-03-11 16:35:29.357 +0000",
            title: "test",
            appVersion: "1.0.0",
            buildVersion: "1",
            osVersion: "iOS 13",
            deviceType: "iPhone",
            sessionId: "12345-12345",
            network: "wifi",
            carrier: "",
            deviceId: "12345-12345",
            eventIdentifier:"12345-12345",
            crashedWithoutSession: false,
            report: report
        )
        
        XCTAssertNotNil(crash)
        XCTAssertNotNil(crash.report)
        XCTAssertNotNil(crash.title)
        XCTAssertNotNil(crash.json)
    }
    
    func testCrashes_dictionary() {
        let report = Data()
        let crash = Crash(
            id: "123",
            timestamp: "2020-03-11 16:35:29.357 +0000",
            title: "test",
            appVersion: "1.0.0",
            buildVersion: "1",
            osVersion: "iOS 13",
            deviceType: "iPhone",
            sessionId: "12345-12345",
            network: "wifi",
            carrier: "",
            deviceId: "12345-12345",
            eventIdentifier:"12345-12345",
            crashedWithoutSession: false,
            report: report
        )
        
        let dict = try? crash.dictionary()
        
        XCTAssertNotNil(dict)
        XCTAssertEqual(dict?.count, 13)
    }
    
    func testCrashes_json() {
        let report = Data()
        let crash = Crash(
            id: "123",
            timestamp: "2020-03-11 16:35:29.357 +0000",
            title: "test",
            appVersion: "1.0.0",
            buildVersion: "1",
            osVersion: "iOS 13",
            deviceType: "iPhone",
            sessionId: "12345-12345",
            network: "wifi",
            carrier: "",
            deviceId: "12345-12345",
            eventIdentifier:"12345-12345",
            crashedWithoutSession: false,
            report: report
        )
        
        let json = try? crash.json()
        
        XCTAssertNotNil(json)
    }
}

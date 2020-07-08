//
//  DeviceTests.swift
//  Tests
//
//  Created by Shams Ahmed on 02/06/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class DeviceTests: XCTestCase {
    
    // MARK: - Property
    
    let device = DeviceFormatter()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testDeviceDetails() {
        XCTAssertNotNil(device.details)
    }
    
    func testDeviceDetails_toJSON() {
        let details = device.details
        
        XCTAssertNotNil(details)
        XCTAssertNotNil(device.jsonString)
        XCTAssertFalse(device.jsonString.isEmpty)
    }
}

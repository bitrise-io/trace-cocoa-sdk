//
//  DeviceFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class DeviceFormatterTests: XCTestCase {
    
    // MARK: - Property
    
    let device = DeviceFormatter()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(device)
        XCTAssertNotNil(device.data)
        XCTAssertNotNil(device.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = device.details
        
        XCTAssertNotNil(metrics)
        XCTAssertNotNil(device.details)
        XCTAssertNotNil(device.timestamp)
        
        XCTAssertEqual(metrics.count, 20)
    }
}

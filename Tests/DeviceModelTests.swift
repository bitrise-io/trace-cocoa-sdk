//
//  DeviceModelTests.swift
//  Tests
//
//  Created by Mukund Agarwal on 23/07/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import XCTest
@testable import Trace

class DeviceModelTests: XCTestCase {

    // MARK: - Tests

    func testErrorNil() {
        XCTAssertNotNil(UIDevice.current.getModelName())
    }
    
    func testDeviceType() {
        XCTAssertEqual(UIDevice.current.getModelName(forcedDevice: "iPhone12,5"), "iPhone 11 Pro Max")
        XCTAssertEqual(UIDevice.current.getModelName(forcedDevice: "iPhone8,2"), "iPhone 6s Plus")
        XCTAssertEqual(UIDevice.current.getModelName(forcedDevice: "iPhone9,1"), "iPhone 7")
        XCTAssertEqual(UIDevice.current.getModelName(forcedDevice: "iPhone11,2"), "iPhone XS")
        XCTAssertEqual(UIDevice.current.getModelName(forcedDevice: "iPhone10,6"), "iPhone X")
        XCTAssertEqual(UIDevice.current.getModelName(forcedDevice: "iPhone10,5"), "iPhone 8 Plus")
    }
}

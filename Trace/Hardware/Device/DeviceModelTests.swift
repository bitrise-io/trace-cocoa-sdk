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
        XCTAssertNotNil(UIDevice.current.modelName)
    }
}

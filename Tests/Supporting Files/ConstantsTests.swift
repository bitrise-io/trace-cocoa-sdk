//
//  ConstantsTests.swift
//  Tests
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class ConstantsTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testName() {
        XCTAssertEqual(Constants.SDK.name.rawValue, "Trace")
    }
}


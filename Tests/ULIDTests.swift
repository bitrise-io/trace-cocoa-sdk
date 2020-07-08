//
//  ULIDTests.swift
//  Tests
//
//  Created by Shams Ahmed on 24/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class ULIDTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testULID() {
        let ulid = ULID()
        
        XCTAssertNotNil(ulid.string)
        XCTAssertTrue(ulid.string.contains(ulid.time))
        XCTAssertTrue(ulid.string.contains(ulid.random))
    }
    
    func testULID_doesNotEqual() {
        let ulid1 = ULID()
        let ulid2 = ULID.string
        
        XCTAssertNotNil(ulid1.string)
        XCTAssertNotNil(ulid2)
        XCTAssertNotEqual(ulid1.string, ulid2)
    }
}

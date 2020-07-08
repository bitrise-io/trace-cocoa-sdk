//
//  HostTests.swift
//  Tests
//
//  Created by Shams Ahmed on 12/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class HostTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testHost() {
        let host: HostProtocol = Host()
        
        XCTAssertNotNil(host.hostBasicInfo)
        XCTAssertNotNil(host.machHost)
    }
}

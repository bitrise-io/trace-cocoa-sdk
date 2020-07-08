//
//  ConnectivityTests.swift
//  Tests
//
//  Created by Shams Ahmed on 13/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class ConnectivityTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testConnectivityInterface() {
        let connectivity = Connectivity()
        
        XCTAssertNotNil(connectivity.interface)
        XCTAssertNotNil(connectivity.interface.timestamp)
    }
    
    func testReachability() {
        let reachability = Connectivity.Reachability()
        
        XCTAssertNotNil(reachability)
        XCTAssertNotEqual(reachability.interface, Connectivity.Interface.cellular)
    }
}

//
//  TraceConfigurationInteractorTests.swift
//  Tests
//
//  Created by Shams Ahmed on 17/05/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class TraceConfigurationInteractorTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    /// Use integration test target for .plist checks
    func testConfiguration_fails() {
        let network = Network()
        let configuration = TraceConfigurationInteractor(network: network)
        
        XCTAssertFalse(configuration.setup())
    }
}

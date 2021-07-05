//
//  StartupTests.swift
//  Tests
//
//  Created by Shams Ahmed on 06/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class StartupTests: XCTestCase {
    
    // MARK: - Property
    
    var startup: Startup? = Startup()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        startup?.stopObserver()
        
        startup = nil
    }
    
    // MARK: - Tests
    
    func testSendNotification() {
        var result = false
        let notification = Notification(name: UIApplication.didBecomeActiveNotification)
        
        Trace.shared.queue.observation = { _ in result = true }
        
        NotificationCenter.default.post(notification)
        
        XCTAssertTrue(result)
    }
}

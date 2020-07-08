//
//  StartupTests.swift
//  Tests
//
//  Created by Shams Ahmed on 06/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class StartupTests: XCTestCase {
    
    // MARK: - Property
    
    let startup = Startup()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
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

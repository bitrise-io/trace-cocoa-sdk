//
//  LifecycleTests.swift
//  Tests
//
//  Created by Shams Ahmed on 06/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class LifecycleTests: XCTestCase {
    
    // MARK: - Property
    
    let lifecycle = Lifecycle()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testSendNotification() {
        var result = false
        
        Trace.shared.queue.observation = { _ in result = true }
        
        [
            UIApplication.didFinishLaunchingNotification,
            UIApplication.willEnterForegroundNotification,
            UIApplication.didEnterBackgroundNotification,
            UIApplication.willTerminateNotification,
            UIApplication.didReceiveMemoryWarningNotification
        ].forEach { NotificationCenter.default.post(Notification(name: $0)) }
        
        XCTAssertTrue(result)
    }
}

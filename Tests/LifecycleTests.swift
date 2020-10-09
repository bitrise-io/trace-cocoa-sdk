//
//  LifecycleTests.swift
//  Tests
//
//  Created by Shams Ahmed on 06/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
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
    
    func testSendNotification_passes() {
        var result = false
        
        Trace.shared.queue.observation = nil
        Trace.shared.queue.observation = { _ in result = true }
        
        [
            UIApplication.didFinishLaunchingNotification,
            UIApplication.didEnterBackgroundNotification,
            UIApplication.willEnterForegroundNotification,
            UIApplication.willTerminateNotification,
            UIApplication.didReceiveMemoryWarningNotification
        ].forEach { NotificationCenter.default.post(Notification(name: $0)) }
        
        XCTAssertTrue(result)
        
        Trace.shared.queue.observation = nil
    }
    
    func testSendNotification_foreground_observationDoesNotGetTriggered() {
        var result = false
        
        Trace.shared.queue.observation = nil
        Trace.shared.queue.observation = { _ in result = true }
        
        [UIApplication.didFinishLaunchingNotification].forEach {
            NotificationCenter.default.post(Notification(name: $0))
        }
        
        XCTAssertFalse(result)
        
        Trace.shared.queue.observation = nil
    }
    
    func testSendNotification_foreground_observationDoesGetTriggered() {
        var result = false
        
        Trace.shared.queue.observation = nil
        Trace.shared.queue.observation = { _ in result = true }
        
        [
            UIApplication.didEnterBackgroundNotification,
            UIApplication.willEnterForegroundNotification
        ].forEach { NotificationCenter.default.post(Notification(name: $0)) }
        
        XCTAssertTrue(result)
        
        Trace.shared.queue.observation = nil
    }
    
    func testStartupTrace_cold() {
        sleep(1)
        
        let before = Trace.shared.tracer.traces.count
        
        NotificationCenter.default.post(
            Notification(name: UIApplication.willEnterForegroundNotification)
        )
        
        sleep(1)
        
        let willEnter = Trace.shared.tracer.traces.count
        
        NotificationCenter.default.post(
            Notification(name: UIApplication.didBecomeActiveNotification)
        )
        
        sleep(1)
        
        let becomeActive = Trace.shared.tracer.traces.count
        
        XCTAssertGreaterThan(willEnter, before)
        XCTAssertEqual(becomeActive, willEnter - 1)
    }
}

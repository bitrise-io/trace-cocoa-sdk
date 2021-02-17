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
    
    private var observation: ((Metrics) -> Void)?
    
    // MARK: - Setup
    
    override func setUp() {
        observation = nil
        Trace.shared.queue.observation = nil
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testSendNotification_passes() {
        let async = expectation(description: "test")
        async.assertForOverFulfill = false
        
        let queue = Trace.shared.queue
        
        queue.observation = nil
        observation = nil
        
        observation = { _ in async.fulfill() }
        
        queue.observation = observation
        
        sleep(1)
        
        [
            UIApplication.didFinishLaunchingNotification,
            UIApplication.didEnterBackgroundNotification,
            UIApplication.willEnterForegroundNotification,
            UIApplication.willTerminateNotification,
            UIApplication.didReceiveMemoryWarningNotification
        ].forEach { NotificationCenter.default.post(Notification(name: $0)) }
        
        wait(for: [async], timeout: 2.5)
        
        queue.observation = nil
    }
    
    func testSendNotification_foreground_observationDoesNotGetTriggered() {
        var result = false
        
        Trace.shared.queue.observation = nil
        observation = nil
        
        observation = { _ in result = true }
        
        Trace.shared.queue.observation = observation
        
        [UIApplication.didFinishLaunchingNotification].forEach {
            NotificationCenter.default.post(Notification(name: $0))
        }
        
        XCTAssertFalse(result)
        
        Trace.shared.queue.observation = nil
    }
    
    func testSendNotification_foreground_observationDoesGetTriggered() {
        var result = false
        
        Trace.shared.queue.observation = nil
        observation = nil
        
        observation = { _ in result = true }
        
        Trace.shared.queue.observation = observation
        
        [
            UIApplication.didEnterBackgroundNotification,
            UIApplication.willEnterForegroundNotification
        ].forEach { NotificationCenter.default.post(Notification(name: $0)) }
        
        sleep(1)
        
        XCTAssertTrue(result)
        
        Trace.shared.queue.observation = nil
    }
    
    func testStartupTrace_cold() {
        sleep(1)
        
        let notificationCenter = NotificationCenter.default
        let tracer = Trace.shared.tracer
        
        let before = tracer.traces.count
        
        notificationCenter.post(
            Notification(name: UIApplication.willEnterForegroundNotification)
        )
        
        sleep(1)
        
        let willEnter = tracer.traces.count
        
        notificationCenter.post(
            Notification(name: UIApplication.didBecomeActiveNotification)
        )
        
        sleep(2)
        
        let becomeActive = tracer.traces.count
        
        XCTAssertGreaterThan(willEnter, before)
        XCTAssertLessThanOrEqual(becomeActive, willEnter)
    }
}

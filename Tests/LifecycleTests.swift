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
    
    var lifecycle: Lifecycle? = Lifecycle()
    
    private var observation: ((Metrics) -> Void)?
    
    // MARK: - Setup
    
    override func setUp() {
        observation = nil
        Trace.shared.queue.observation = nil
    }
    
    override func tearDown() {
        lifecycle?.stopObserver()
        lifecycle = nil
    }
    
    // MARK: - Tests
    
    func testSendNotification_passes() {
        let async = expectation(description: "test")
        async.assertForOverFulfill = false
        
        let queue = Trace.shared.queue
        let notificationCenter = NotificationCenter.default
        
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
        ].forEach { notificationCenter.post(Notification(name: $0)) }
        
        wait(for: [async], timeout: 2.5)
        
        queue.observation = nil
        
        XCTAssertNotNil(notificationCenter)
    }
    
    func testSendNotification_foreground_observationDoesNotGetTriggered() {
        var result = false
        let notificationCenter = NotificationCenter.default
        
        Trace.shared.queue.observation = nil
        observation = nil
        
        observation = { _ in result = true }
        
        Trace.shared.queue.observation = observation
        
        [UIApplication.didFinishLaunchingNotification].forEach {
            notificationCenter.post(Notification(name: $0))
        }
        
        XCTAssertFalse(result)
        XCTAssertNotNil(notificationCenter)
        
        Trace.shared.queue.observation = nil
    }
    
    // this tests is known to crash
    func testSendNotification_foreground_observationDoesGetTriggered() {
        var result = false
        let notificationCenter = NotificationCenter.default
        
        Trace.shared.queue.observation = nil
        observation = nil
        
        observation = { _ in
            result = true
        }
        
        Trace.shared.queue.observation = observation
        
        [
            UIApplication.didEnterBackgroundNotification,
            UIApplication.willEnterForegroundNotification
        ].forEach {
            notificationCenter.post(Notification(name: $0))
        }
        
        sleep(1)
        
        XCTAssertTrue(result)
        XCTAssertNotNil(notificationCenter)
        
        sleep(1)
    }
    
    func testStartupTrace_cold() {
        let notificationCenter = NotificationCenter.default
        let tracer = Trace.shared.tracer
        let initial = tracer.traces.count
        
        sleep(1)
        
        notificationCenter.post(
            Notification(name: UIApplication.willEnterForegroundNotification)
        )
        
        sleep(1)
        
        let willEnter = tracer.traces.count
        
        notificationCenter.post(
            Notification(name: UIApplication.didBecomeActiveNotification)
        )
        
        sleep(2)
        
        XCTAssertNotNil(notificationCenter)
        XCTAssertGreaterThanOrEqual(willEnter, initial)
        XCTAssertLessThanOrEqual(tracer.traces.count, willEnter)
    }
}

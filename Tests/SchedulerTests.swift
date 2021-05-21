//
//  SchedulerTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class SchedulerTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testMetricRequest() {
        let network = Network()
        let scheduler = Scheduler(with: network)
        let metric = Metric(descriptor: Metric.Descriptor(name: .appCrashTotal, description: "", unit: .bytes, type: .cumulativeDistribution, keys: []), timeseries: [])
        let resource = Resource(from: ["test":"test"])
        let metrics = Metrics([metric], resource: resource)
        
        let test1 = expectation(description: "test1")
        
        scheduler.schedule(metrics) { _ in
            test1.fulfill()
        }
        
        wait(for: [test1], timeout: 10)
    }
    
    func testTraceRequest() {
        let network = Network()
        let scheduler = Scheduler(with: network)
        let trace = TraceModel(id: "12345678", spans: [], resource: nil, type: .view)
        let test2 = expectation(description: "test2")
        
        scheduler.schedule(trace) { _ in
            test2.fulfill()
        }
        
        wait(for: [test2], timeout: 10)
    }
    
    func testCrashRequest() {
        let network = Network()
        let scheduler = Scheduler(with: network)
        let crash = Crash(id: "id", timestamp: "1", title: "title", appVersion: "1", buildVersion: "1", osVersion: "1", deviceType: "ios", sessionId: "s1", network: "network", carrier: "c1", deviceId: "d1", eventIdentifier: "e1", crashedWithoutSession: false, report: Data())
        let test3 = expectation(description: "test3")
        
        scheduler.schedule(crash) { _ in
            test3.fulfill()
        }
        
        wait(for: [test3], timeout: 10)
    }
}

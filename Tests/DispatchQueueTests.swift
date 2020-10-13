//
//  DispatchQueueTests.swift
//  Tests
//
//  Created by Shams Ahmed on 13/10/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class DispatchQueueTests: XCTestCase {
    
    // MARK: - Property
    
    let dispatchQueue = DispatchQueue(label: "DispatchQueueTests", qos: .background)

    let dispatchQueueSynchronized = DispatchQueueSynchronized(
        label: "testDispatchQueueSynchronized_sync_true",
        qos: .background
    )
    
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testOnMainThread_true() {
        var result = false
        
        result = DispatchQueue.isMainQueue
        
        XCTAssertTrue(result)
    }
    
    func testOnMainThread_false() {
        var result = false
        
        result = DispatchQueue.global(qos: .background).sync {
            DispatchQueue.isMainQueue
        }
        
        XCTAssertFalse(result)
    }
    
    func testOnMainThreadFromBackground_true() {
        var result = false
        
        let testExpectation = expectation(description: "test")
        
        DispatchQueue(label: "test").async {
            DispatchQueue.main.async {
                result = DispatchQueue.isMainQueue
                testExpectation.fulfill()
            }
        }
        
        wait(for: [testExpectation], timeout: 2.0)
        
        XCTAssertTrue(result)
    }
    
    func testDispatchQueueSynchronized_NotInQueue_sync() {
        var result = false
        
        dispatchQueueSynchronized.sync {
            result = true
        }
        
        XCTAssertTrue(result)
    }
    
    func testDispatchQueueSynchronized_NotInQueue_global_sync() {
        var result = false
        let testExpectation = expectation(description: "test")
        
        DispatchQueue.global().sync {
            self.dispatchQueueSynchronized.sync {
                result = true
                
                testExpectation.fulfill()
            }
        }
        
        wait(for: [testExpectation], timeout: 2.0)
        
        XCTAssertTrue(result)
    }
    
    func testDispatchQueueSynchronized_NotInQueue_main_async() {
        var result = false
        let testExpectation = expectation(description: "test")
        
        DispatchQueue.main.async {
            self.dispatchQueueSynchronized.sync {
                result = true
                
                testExpectation.fulfill()
            }
        }
        
        wait(for: [testExpectation], timeout: 2.0)
        
        XCTAssertTrue(result)
    }
    
    func testDispatchQueueSynchronized_inQueueSync() {
        var result = false
        let testExpectation = expectation(description: "test")
        
        dispatchQueueSynchronized.sync {
            self.dispatchQueueSynchronized.sync {
                result = true
                
                testExpectation.fulfill()
            }
        }
        
        wait(for: [testExpectation], timeout: 2.0)
        
        XCTAssertTrue(result)
    }
    
    func testDispatchQueueSynchronized_inQueueASync() {
        var result = false
        let testExpectation = expectation(description: "test")
        
        dispatchQueueSynchronized.async {
            self.dispatchQueueSynchronized.sync {
                result = true
                
                testExpectation.fulfill()
            }
        }
        
        wait(for: [testExpectation], timeout: 2.0)
        
        XCTAssertTrue(result)
    }
}

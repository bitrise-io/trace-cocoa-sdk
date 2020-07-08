//
//  CrashControllerTests.swift
//  Tests
//
//  Created by Shams Ahmed on 10/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class CrashControllerTests: XCTestCase {
    
    // MARK: - Property
    
    var newCrash: CrashController {
        let network = Network()
        let scheduler = Scheduler(with: network)
        
        let crash = CrashController(with: scheduler)
        crash.setup()
        
        return crash
    }
    
    // MARK: - Tests
    
    func testAddingUserInfo() {
        let crash = newCrash
        
        XCTAssertEqual(crash.userInfo.count, 0)
        
        crash.userInfo = ["test": "one"]
        
        XCTAssertEqual(crash.userInfo.count, 1)
        XCTAssertEqual(crash.userInfo["test"] as! String, "one")
    }
    
    func testRemovingUserInfo() {
        let crash = newCrash
        
        XCTAssertEqual(crash.userInfo.count, 0)
        
        crash.userInfo = ["test": "two"]
        crash.userInfo.removeAll()
        
        XCTAssertEqual(crash.userInfo.count, 0)
        XCTAssertNil(crash.userInfo["test"])
    }
    
    func testUpdatingUserInfo() {
        let crash = newCrash
        
        XCTAssertEqual(crash.userInfo.count, 0)
        
        crash.userInfo["test"] = "one"
        
        XCTAssertEqual(crash.userInfo.count, 1)
        
        crash.userInfo["test"] = "two"
        
        XCTAssertEqual(crash.userInfo["test"] as! String, "two")
    }
    
    func testCrashObserver() {
        let crash = newCrash
        crash.allReports { reports in
            XCTAssertNotNil(reports)
        }
        
        XCTAssertTrue(crash.allReports.isEmpty)
    }
    
    func testSend_failsWithBadData() {
        let crash = newCrash
        let badData = Data()
        
        let result = crash.send(report: badData)
        
        XCTAssertFalse(result)
    }
    
    func testSend_passes() {
        guard let url = Bundle(for: Self.self).url(forResource: "outOfBound", withExtension: "crash") else {
            return XCTFail("Could not locate test fails")
        }
       
        do {
            let crash = newCrash
            let data = try Data(contentsOf: url)
            let result = crash.send(report: data)
            
            XCTAssertTrue(result)
        } catch {
            XCTFail("Could not open crash file")
        }
    }
}

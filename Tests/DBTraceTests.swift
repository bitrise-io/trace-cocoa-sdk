//
//  DBTraceTests.swift
//  Tests
//
//  Created by Shams Ahmed on 01/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import Trace

final class DBTraceTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testReadObject() {
        let persistent = Database().persistent
        let request: NSFetchRequest<DBTrace> = DBTrace.fetchRequest()
        let context = persistent.privateContext
        
        let trace = DBTrace(context: context)
        trace.date = Date()
        trace.json = NSData()
        trace.traceId = "t1"
        
        XCTAssertNotNil(trace.date)
        XCTAssertNotNil(trace.json)
        XCTAssertNotNil(trace.traceId)
        XCTAssertEqual(trace.traceId, "t1")
        XCTAssertNotNil(request)
    }
}

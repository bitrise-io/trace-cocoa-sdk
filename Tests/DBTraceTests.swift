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
        let database: Database = {
            guard Trace.currentSession == 0 else {
                print("Using existing database since Trace SDK is active")
                
                return Trace.shared.database
            }
            
            return Database()
        }()
        let persistent = database.persistent
        let request: NSFetchRequest<DBTrace> = DBTrace.fetchRequest()
        let context = persistent.privateContext
        let entity = Entities().trace
        
        let trace = DBTrace(entity: entity, insertInto: context)
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

//
//  DBMetricTests.swift
//  Tests
//
//  Created by Shams Ahmed on 13/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import Trace

final class DBMetricTests: XCTestCase {
    
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
        let request: NSFetchRequest<DBMetric> = DBMetric.fetchRequest()
        let context = persistent.privateContext
        let entity = Entities().metric
        
        let metric = DBMetric(entity: entity, insertInto: context)
        metric.date = Date()
        metric.json = NSData()
        metric.name = "test"
        
        XCTAssertNotNil(metric.date)
        XCTAssertNotNil(metric.json)
        XCTAssertNotNil(metric.name)
        XCTAssertEqual(metric.name, "test")
        XCTAssertNotNil(request)
    }
}

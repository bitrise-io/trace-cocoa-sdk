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
        let persistent = Database().persistent
        let request: NSFetchRequest<DBMetric> = DBMetric.fetchRequest()
        
        let metric = DBMetric(context: persistent.privateContext)
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

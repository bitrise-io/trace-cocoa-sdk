//
//  DatabaseTests.swift
//  Tests
//
//  Created by Shams Ahmed on 13/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class DatabaseTests: XCTestCase {
    
    // MARK: - Property
    
    let database = Database()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testDatabase() {
        XCTAssertNotNil(database)
        XCTAssertNotNil(database.persistent)
    }
    
    func testDatabase_reset() {
        database.reset()
        
        sleep(2)
        
        let count = database.dao.metric.count(in: .view)
        
        XCTAssertEqual(count, 0)
    }
    
    func testDatabase_saveAll() {
        let descriptor = Metric.Descriptor(name: .appRequestSizeBytes, description: "test", unit: .percent, type: .cumulativeDistribution, keys: [])
        
        database.dao.metric.create(with: MetricDAO.M(descriptor: descriptor, timeseries: []), save: false)
        
        XCTAssertEqual(database.dao.metric.count(in: .background), 0)
        
        database.saveAll {
            sleep(2)
            
            XCTAssertEqual(self.database.dao.metric.count(in: .view), 1)
        }  
    }
}

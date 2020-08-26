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
    
    let database: Database = {
        guard Trace.currentSession == 0 else {
            print("Using existing database since Trace SDK is active")
            
            return Trace.shared.database
        }
        
        return Database()
    }()
    
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
        
        sleep(1)
        
        let count = database.dao.metric.count(in: .view)
        
        XCTAssertEqual(count, 0)
    }
    
    func testDatabase_saveAll_false() {
        let descriptor = Metric.Descriptor(name: .appRequestSizeBytes, description: "test 1", unit: .percent, type: .cumulativeDistribution, keys: [])
        
        database.dao.metric.create(with: MetricDAO.M(descriptor: descriptor, timeseries: []), save: false)
        
        XCTAssertEqual(database.dao.metric.count(in: .background), 0)
        
        database.saveAll {
            sleep(1)
            
            XCTAssertEqual(self.database.dao.metric.count(in: .view), 0)
        }  
    }
    
    func testDatabase_saveAll_true() {
        database.reset()
        
        let descriptor = Metric.Descriptor(name: .appRequestSizeBytes, description: "test 2", unit: .percent, type: .cumulativeDistribution, keys: [])
        
        XCTAssertEqual(database.dao.metric.count(in: .background), 0)
        
        database.dao.metric.create(with: [MetricDAO.M(descriptor: descriptor, timeseries: [])], save: true, synchronous: true)
        
        database.saveAll {
            sleep(1)
            
            XCTAssertEqual(self.database.dao.metric.count(in: .view), 1)
        }
    }
}

//
//  DatabaseTests.swift
//  PerformanceTests
//
//  Created by Mukund Agarwal on 19/05/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import Trace

class DatabaseTests: XCTestCase {
    
    // MARK: - Property
    
    let database = Database()
    
    // MARK: - Setup
    
    override func setUp() {
        database.reset()
    }
    
    // MARK: - Tests
    
    func testCpuMemoryPerformance_write_10objects() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            writeToDatabase(times: 10)
        }
    }
    
    func testCpuMemoryPerformance_write_100objects() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            writeToDatabase(times: 100)
        }
    }
    
    func testCpuMemoryPerformance_write_1000objects() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            writeToDatabase(times: 1000)
        }
    }
    
    func testCpuMemoryPerformance_read_10objects() {
        writeToDatabase(times: 1)
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            readFromDatabase(times: 10)
        }
    }
    
    func testCpuMemoryPerformance_read_100objects() {
        writeToDatabase(times: 1)
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            readFromDatabase(times: 100)
        }
    }
    
    func testCpuMemoryPerformance_read_1000objects() {
        writeToDatabase(times: 1)
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            readFromDatabase(times: 1000)
        }
    }
    
    
    func testCpuMemoryPerformance_count_10objects() {
        writeToDatabase(times: 10)
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            countMetricsInDatabase(times: 10)
        }
    }
    
    func testCpuMemoryPerformance_getOneObject() {
        writeToDatabase(times: 1)
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            getOneObjectFromDatabase()
        }
    }
    
    func testCpuMemoryPerformance_getAllObjects() {
        writeToDatabase(times: 10)
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            getAllObjectsFromDatabase()
        }
    }
    
    // MARK: - Private methods
    
    private func writeToDatabase(times: Int) {
        for i in 0...times {
            let descriptor = Metric.Descriptor(name: .appRequestSizeBytes, description: "test" + String(i), unit: .percent, type: .cumulativeDistribution, keys: [])
            
            database.dao.metric.create(with: MetricDAO.M(descriptor: descriptor, timeseries: []), save: false)
        }
        database.saveAll()
    }
    
    private func readFromDatabase(times: Int) {
        for _ in 0...times {
            let _ = database.persistent
            let _: NSFetchRequest<DBMetric> = DBMetric.fetchRequest()
        }
    }
    
    private func countMetricsInDatabase(times: Int) {
        for _ in 0...times {
            let _ = database.persistent
            let _: NSFetchRequest<DBMetric> = DBMetric.fetchRequest()
            
            let dao = database.dao.metric
            let _ = dao.count(in: .view)
        }
    }
    
    private func getOneObjectFromDatabase() {
        let _ = database.persistent
        let _: NSFetchRequest<DBMetric> = DBMetric.fetchRequest()
        
        let dao = database.dao.metric
        let _ = dao.one(in: .view)
    }

    private func getAllObjectsFromDatabase() {
        let _ = database.persistent
        let _: NSFetchRequest<DBMetric> = DBMetric.fetchRequest()
        
        let dao = database.dao.metric
        let _ = dao.all(in: .view)
    }
    
}

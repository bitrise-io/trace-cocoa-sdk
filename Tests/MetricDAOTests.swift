//
//  MetricDAOTests.swift
//  Tests
//
//  Created by Shams Ahmed on 01/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import Trace

final class MetricDAOTests: XCTestCase {
    
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
    
    func testDAO_saveMetrics() {
        let dao = database.dao.metric
        let descriptor = Metric.Descriptor(
            name: .appRequestSizeBytes,
            description: "test1",
            unit: .ms,
            type: .int64, keys: [])
        let model = Metric(descriptor: descriptor, timeseries: [])
        let metrics = Metrics([model])
        
        dao.create(with: metrics, save: true)
    }
    
    func testDAO_save() {
        let dao = database.dao.metric
        let descriptor = Metric.Descriptor(
            name: .appRequestSizeBytes,
            description: "test1",
            unit: .ms,
            type: .int64, keys: [])
        let model = Metric(descriptor: descriptor, timeseries: [])
        
        dao.create(with: [model], save: true, synchronous: true)
    }
    
    func testDAO() {
        let dao = database.dao.metric
        let descriptor = Metric.Descriptor(
            name: .appRequestSizeBytes,
            description: "test2",
            unit: .ms,
            type: .int64, keys: [])
        let model = Metric(descriptor: descriptor, timeseries: [])
        
        dao.create(with: model, save: false)
    }
    
    func testRequest() {
        let dao = database.dao.metric
        let request = dao.fetchRequest
        
        XCTAssertNotNil(request)
        XCTAssertTrue(request.entityName?.contains("Metric") == true)
    }
    
    func testRequest_controller() {
        let dao = database.dao.metric
        let controller = dao.fetchedResultsController(for: .view, sorting: [])

        XCTAssertNotNil(controller)
        XCTAssertNotNil(controller.fetchRequest)
        XCTAssertTrue(controller.fetchRequest.entityName?.contains("Metric") == true)
    }

    func testRequest_controller_fetch() {
        let dao = database.dao.metric
        let controller = dao.fetchedResultsController(for: .view, sorting: [])

        do {
            try controller.performFetch()
        } catch {
            XCTFail("Failed to perform fetch")
        }

        XCTAssertNotNil(controller)
        XCTAssertNotNil(controller.fetchRequest)
        XCTAssertTrue(controller.fetchRequest.entityName?.contains("Metric") == true)
    }

    func testCount_zero() {
        database.reset()

        let dao = database.dao.metric
        let count = dao.count(in: .view)

        XCTAssertEqual(count, 0)
    }

    func testCount_one() {
        let model = Metric(descriptor: Metric.Descriptor(name: .appMemoryBytes, description: "", unit: .ms, type: .cumulativeDouble, keys: []), timeseries: [])

        let dao = database.dao.metric
        dao.create(with: [model], save: true, synchronous: true)

        let count = dao.count(in: .view)

        XCTAssertGreaterThanOrEqual(count, 1)
    }

    func testFetch_one() {
        let model = Metric(descriptor: Metric.Descriptor(name: .appMemoryBytes, description: "", unit: .ms, type: .cumulativeDouble, keys: []), timeseries: [])

        let dao = database.dao.metric
        dao.create(with: [model], save: true, synchronous: true)

        let one = dao.one(in: .view)

        XCTAssertNotNil(one)
    }

    func testFetch_all() {
        let dao = database.dao.metric
        let all = dao.all(in: .view)

        XCTAssertNotNil(all)
    }

    func testFetch_allInBackground() {
        let expect = expectation(description: "all in background")

        var metrics: [DBMetric] = []

        let dao = database.dao.metric
        dao.allInBackground {
            metrics.append(contentsOf: $0)

            expect.fulfill()
        }

        XCTAssertNotNil(dao)

        wait(for: [expect], timeout: 2)
    }

    func testUpdate() {
        let expect = expectation(description: "update check")
        let model = Metric(descriptor: Metric.Descriptor(name: .appMemoryBytes, description: "", unit: .ms, type: .cumulativeDouble, keys: []), timeseries: [])

        let dao = database.dao.metric
        dao.create(with: [model], save: true, synchronous: true)

        let dbModel = dao.one(in: .view)

        XCTAssertNotNil(dbModel)

        let date = Date()

        dao.update(id: dbModel!.objectID) { trace -> Bool in
            XCTAssertNotNil(trace)

            trace?.date = date

            expect.fulfill()

            return true
        }

        wait(for: [expect], timeout: 5)

        sleep(1)

        XCTAssertEqual(dbModel?.date, date)
    }

    func testUpdates() {
        let expect = expectation(description: "update check")
        let model = Metric(descriptor: Metric.Descriptor(name: .appMemoryBytes, description: "", unit: .ms, type: .cumulativeDouble, keys: []), timeseries: [])

        let dao = database.dao.metric
        dao.create(with: [model], save: true, synchronous: true)

        let dbModels = dao.all(in: .view)

        XCTAssertNotNil(dbModels)

        let date = Date()

        dao.update(ids: dbModels.map { $0.objectID }) { traces -> Bool in
            XCTAssertNotNil(traces)

            traces.forEach { $0.date = date }

            expect.fulfill()

            return true
        }

        wait(for: [expect], timeout: 5)
    }

    func testZ_delete() {
        let model = Metric(descriptor: Metric.Descriptor(name: .appMemoryBytes, description: "", unit: .ms, type: .cumulativeDouble, keys: []), timeseries: [])

        let dao = database.dao.metric
        let count = dao.count(in: .view)

        dao.create(with: [model], save: true, synchronous: true)

        sleep(1)

        let dbModel = dao.one(in: .view)
        let ids = [dbModel.map { $0.objectID }!]
        
        dao.delete(ids)
        
        XCTAssertGreaterThanOrEqual(dao.count(in: .view), count)
    }
}

//
//  TraceDAOTests.swift
//  Tests
//
//  Created by Shams Ahmed on 01/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import Trace

final class TraceDAOTests: XCTestCase {
    
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
    
    func testDAO_save() {
        let dao = database.dao.trace
        let model = TraceModel(spans: [])
        
        dao.create(with: model, save: true)
    }
    
    func testDAO() {
        let dao = database.dao.trace
        let model = TraceModel(spans: [])
        
        dao.create(with: model, save: false)
    }
    
    func testRequest() {
        let dao = database.dao.trace
        let request = dao.fetchRequest
        
        XCTAssertNotNil(request)
        XCTAssertTrue(request.entityName?.contains("Trace") == true)
    }
    
    func testRequest_controller() {
        let dao = database.dao.trace
        let controller = dao.fetchedResultsController(for: .view, sorting: [])
        
        XCTAssertNotNil(controller)
        XCTAssertNotNil(controller.fetchRequest)
        XCTAssertTrue(controller.fetchRequest.entityName?.contains("Trace") == true)
    }
    
    func testRequest_controller_fetch() {
        let dao = database.dao.trace
        let controller = dao.fetchedResultsController(for: .view, sorting: [])
        
        do {
            try controller.performFetch()
        } catch {
            XCTFail("Failed to perform fetch")
        }
        
        XCTAssertNotNil(controller)
        XCTAssertNotNil(controller.fetchRequest)
        XCTAssertTrue(controller.fetchRequest.entityName?.contains("Trace") == true)
    }
    
    func testCount_zero() {
        database.reset()
        
        let dao = database.dao.trace
        let count = dao.count(in: .view)
        
        XCTAssertEqual(count, 0)
    }
    
    func testCount_one() {
        let model = TraceModel(spans: [])
        
        let dao = database.dao.trace
        dao.create(with: [model], save: true, synchronous: true)
        
        let count = dao.count(in: .view)
        
        XCTAssertEqual(count, 1)
    }
    
    func testFetch_one() {
        let model = TraceModel(spans: [])
        
        let dao = database.dao.trace
        dao.create(with: [model], save: true, synchronous: true)
        
        let one = dao.one(in: .view)
        
        XCTAssertNotNil(one)
    }
    
    func testFetch_all() {
        let dao = database.dao.trace
        let all = dao.all(in: .view)
        
        XCTAssertNotNil(all)
    }
    
    func testFetch_allInBackground() {
        let expect = expectation(description: "all in background")
        
        var traces: [DBTrace] = []
        
        let dao = database.dao.trace
        dao.allInBackground {
            traces.append(contentsOf: $0)
            
            expect.fulfill()
        }
        
        XCTAssertNotNil(dao)
        
        wait(for: [expect], timeout: 2)
    }
    
    func testUpdate() {
        let expect = expectation(description: "update check")
        let model = TraceModel(spans: [])
        
        let dao = database.dao.trace
        dao.create(with: [model], save: true, synchronous: true)
        
        sleep(1)
        
        let dbModel = dao.one(in: .view)
        
        XCTAssertNotNil(dbModel)
        
        if dbModel == nil {
            expect.fulfill()
            
            XCTFail("DB object does not exist in database")
            
            return;
        }
        
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
        let model = TraceModel(spans: [])
        
        let dao = database.dao.trace
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
        let model = TraceModel(spans: [])
        
        let dao = database.dao.trace
        let count = dao.count(in: .view)
        
        dao.create(with: [model], save: true, synchronous: true)
        
        sleep(1)
        
        let dbModel = dao.one(in: .view)
        let ids = [dbModel.map { $0.objectID }!]
        
        dao.delete(ids)
        
        sleep(1)
        
        XCTAssertGreaterThanOrEqual(dao.count(in: .view), count)
    }
}

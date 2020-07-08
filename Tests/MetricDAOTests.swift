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
    
    let database = Database()
    
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
}

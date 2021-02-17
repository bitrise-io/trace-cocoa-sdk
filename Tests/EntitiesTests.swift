//
//  EntitiesTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class EntitiesTests: XCTestCase {
    
    // MARK: - Property
    
    let entities = Entities()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testEntities() {
        let names = ["DBTrace", "DBMetric"]
        
        XCTAssertEqual(entities.managedObjectModel.entities.count, 2)
        
        let hasTrace = names.contains(entities.managedObjectModel.entities[0].name!)
        let hasMetric = names.contains(entities.managedObjectModel.entities[1].name!)
        
        XCTAssertTrue(hasTrace)
        XCTAssertTrue(hasMetric)
    }
    
    func testNameSpace_usingEntity() {
        let traceNamespace = entities.trace.managedObjectClassName
        let metricNamespace = entities.metric.managedObjectClassName
        
        XCTAssertEqual(traceNamespace, "Trace.DBTrace")
        XCTAssertEqual(metricNamespace, "Trace.DBMetric")
    }
    
    func testNameSpace_usingString() {
        let traceNamespace = String(reflecting: DBTrace.self)
        let metricNamespace = String(reflecting: DBMetric.self)
        
        XCTAssertEqual(traceNamespace, "Trace.DBTrace")
        XCTAssertEqual(metricNamespace, "Trace.DBMetric")
    }
}

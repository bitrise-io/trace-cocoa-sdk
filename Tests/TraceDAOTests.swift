//
//  TraceDAOTests.swift
//  Tests
//
//  Created by Shams Ahmed on 01/10/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
import CoreData
@testable import Trace

final class TraceDAOTests: XCTestCase {
    
    // MARK: - Property
    
    let database = Database()
    
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
}

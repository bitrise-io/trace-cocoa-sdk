//
//  PersistentTests.swift
//  Tests
//
//  Created by Shams Ahmed on 13/08/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import CoreData
import XCTest
@testable import Trace

final class PersistentTests: XCTestCase {
    
    // MARK: - Property
    
    /// Persistent
    internal let persistent: Persistent = {
        let entities = Entities()
        
        let persistent = Persistent(
            name: "BitriseTrace",
            managedObjectModel: entities.managedObjectModel
        )
        persistent.setup()
        
        return persistent
    }()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testPersistent() {
        XCTAssertNotNil(persistent)
        XCTAssertNotNil(persistent.privateContext)
        XCTAssertNotNil(Persistent.defaultDirectoryURL())
    }
}

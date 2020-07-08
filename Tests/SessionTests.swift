//
//  SessionTests.swift
//  Tests
//
//  Created by Shams Ahmed on 06/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class SessionTests: XCTestCase {
    
    // MARK: - Property
    
    lazy var session = Session(timeout: 0.1, delay: 0.1)
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testSession() {
        XCTAssertNil(session.resource)
    }
    
    func testSession_restartDoesntCrash() {
        session.restart()
        
        XCTAssertNotNil(session)
    }
    
    func testSession_wait() {
        XCTAssertNotNil(session)
    }
    
    func testSession_updatingUUID() {
        let current = session.uuid.string
        
        session.restart()
        
        let new = session.uuid.string
        
        XCTAssertNotNil(current)
        XCTAssertNotNil(new)
        XCTAssertNotEqual(current, session.uuid.string)
        XCTAssertNotEqual(new, session.resource?.session)
    }
}

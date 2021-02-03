//
//  SessionTests.swift
//  Tests
//
//  Created by Shams Ahmed on 06/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
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
        XCTAssertNotNil(session.resource)
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
        
        let new = session.uuid.string + "NEW"
        
        XCTAssertNotNil(current)
        XCTAssertNotNil(new)
        XCTAssertNotEqual(current, session.uuid.string)
        XCTAssertNotEqual(new, session.resource.session)
    }
    
    func testNewSessionHas_no_resource() {
        let current = Session(timeout: 0.1, delay: 0.1)
        
        XCTAssertNotNil(current)
        XCTAssertNotNil(current.resource)
    }
    
    func testNewSessionHasResource() {
        let current = Session(timeout: 0.1, delay: 0.1)
        
        XCTAssertNotNil(current.resource)
        
        current.resource = Resource(from: [:])
        
        XCTAssertNotNil(current.resource)
        XCTAssertEqual(current.resource.type, "mobile")
        XCTAssertEqual(current.resource.platform, "")
        XCTAssertEqual(current.resource.appVersion, "")
        XCTAssertEqual(current.resource.uuid, "")
        XCTAssertEqual(current.resource.osVersion, "")
        XCTAssertEqual(current.resource.deviceType, "")
        XCTAssertEqual(current.resource.carrier, "")
        XCTAssertEqual(current.resource.jailbroken, "")
        XCTAssertEqual(current.resource.sdkVersion, "")
        
        XCTAssertNotNil(current.resource.network)
        XCTAssertFalse(current.resource.session.isEmpty)
    }
    
    func testNewSessionHasResource_afterSessionUpdate() {
        let current = Session(timeout: 0.1, delay: 0.1)
        
        XCTAssertNotNil(current.resource)
        
        current.resource = Resource(from: [:])
        current.resource.session = "test"
        
        XCTAssertNotNil(current.resource)
        XCTAssertEqual(current.resource.type, "mobile")
        XCTAssertEqual(current.resource.platform, "")
        XCTAssertEqual(current.resource.appVersion, "")
        XCTAssertEqual(current.resource.uuid, "")
        XCTAssertEqual(current.resource.osVersion, "")
        XCTAssertEqual(current.resource.deviceType, "")
        XCTAssertEqual(current.resource.carrier, "")
        XCTAssertEqual(current.resource.jailbroken, "")
        XCTAssertEqual(current.resource.sdkVersion, "")
        XCTAssertEqual(current.resource.network, "")
        XCTAssertEqual(current.resource.session, current.uuid.string)
    }
    
    func testNewSessionHasResource_afterNetworkUpdate() {
        let current = Session(timeout: 0.1, delay: 0.1)
        
        XCTAssertNotNil(current.resource)
        
        current.resource = Resource(from: [:])
        current.resource.network = "wifi"
        
        XCTAssertNotNil(current.resource)
        XCTAssertEqual(current.resource.type, "mobile")
        XCTAssertEqual(current.resource.platform, "")
        XCTAssertEqual(current.resource.appVersion, "")
        XCTAssertEqual(current.resource.uuid, "")
        XCTAssertEqual(current.resource.osVersion, "")
        XCTAssertEqual(current.resource.deviceType, "")
        XCTAssertEqual(current.resource.carrier, "")
        XCTAssertEqual(current.resource.jailbroken, "")
        XCTAssertEqual(current.resource.sdkVersion, "")
        XCTAssertEqual(current.resource.network, "wifi")
        XCTAssertEqual(current.resource.session, current.uuid.string)
    }
    
    func testNewSessionHasResource_afterSecondNetworkUpdate() {
        let current = Session(timeout: 0.1, delay: 0.1)
        
        XCTAssertNotNil(current.resource)
        
        current.resource = Resource(from: [:])
        current.resource.network = "wifi"
        
        XCTAssertNotNil(current.resource)
        XCTAssertEqual(current.resource.type, "mobile")
        XCTAssertEqual(current.resource.platform, "")
        XCTAssertEqual(current.resource.appVersion, "")
        XCTAssertEqual(current.resource.uuid, "")
        XCTAssertEqual(current.resource.osVersion, "")
        XCTAssertEqual(current.resource.deviceType, "")
        XCTAssertEqual(current.resource.carrier, "")
        XCTAssertEqual(current.resource.jailbroken, "")
        XCTAssertEqual(current.resource.sdkVersion, "")
        XCTAssertEqual(current.resource.network, "wifi")
        XCTAssertEqual(current.resource.session, current.uuid.string)
        
        current.resource.network = "3G"
        
        XCTAssertEqual(current.resource.network, "3G")
    }
    
    func testNewSessionHasResource_afterThirdNetworkUpdate() {
        let current = Session(timeout: 0.1, delay: 0.1)
        
        XCTAssertNotNil(current.resource)
        
        current.resource = Resource(from: [:])
        current.resource.network = "wifi"
        
        XCTAssertNotNil(current.resource)
        XCTAssertEqual(current.resource.type, "mobile")
        XCTAssertEqual(current.resource.platform, "")
        XCTAssertEqual(current.resource.appVersion, "")
        XCTAssertEqual(current.resource.uuid, "")
        XCTAssertEqual(current.resource.osVersion, "")
        XCTAssertEqual(current.resource.deviceType, "")
        XCTAssertEqual(current.resource.carrier, "")
        XCTAssertEqual(current.resource.jailbroken, "")
        XCTAssertEqual(current.resource.sdkVersion, "")
        XCTAssertEqual(current.resource.network, "wifi")
        XCTAssertEqual(current.resource.session, current.uuid.string)
        
        current.resource.network = "3G"
        
        XCTAssertEqual(current.resource.network, "3G")
        
        current.resource.network = "4G"
        
        XCTAssertEqual(current.resource.network, "4G")
    }
    
    func testNewSessionHasResource_afterFailedNetworkUpdate() {
        let current = Session(timeout: 0.1, delay: 0.1)
        
        XCTAssertNotNil(current.resource)
        
        current.resource = Resource(from: [:])
        current.resource.network = "wifi"
        
        XCTAssertNotNil(current.resource)
        XCTAssertEqual(current.resource.type, "mobile")
        XCTAssertEqual(current.resource.platform, "")
        XCTAssertEqual(current.resource.appVersion, "")
        XCTAssertEqual(current.resource.uuid, "")
        XCTAssertEqual(current.resource.osVersion, "")
        XCTAssertEqual(current.resource.deviceType, "")
        XCTAssertEqual(current.resource.carrier, "")
        XCTAssertEqual(current.resource.jailbroken, "")
        XCTAssertEqual(current.resource.sdkVersion, "")
        XCTAssertEqual(current.resource.network, "wifi")
        XCTAssertEqual(current.resource.session, current.uuid.string)
        
        current.resource.network = ""
        
        XCTAssertEqual(current.resource.network, "wifi")
    }
}

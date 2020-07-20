//
//  ResourceTests.swift
//  Tests
//
//  Created by Shams Ahmed on 07/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class ResourceTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testDecode() {
        enum Keys: String, CodingKey {
            case appVersion = "app.version"
            case uuid = "device.id"
            case osVersion = "os.version"
            case deviceType = "device.type"
            case carrier = "device.carrier"
            case network = "device.network"
        }
        
        let details: OrderedDictionary<String, String> = [
            Keys.appVersion.rawValue: "1",
            Keys.uuid.rawValue: "123",
            Keys.osVersion.rawValue: "13",
            Keys.deviceType.rawValue:  "ios",
            Keys.carrier.rawValue: "apple",
            Keys.network.rawValue: "apple"
        ]
        let resource1 = Resource(from: details)
        let json = try! resource1.json()
        let resource2 = try! JSONDecoder().decode(Resource.self, from: json)
        
        XCTAssertNotNil(resource1)
        XCTAssertNotNil(json)
        XCTAssertNotNil(resource2)
    }
    
    func testCompare() {
        enum Keys: String, CodingKey {
            case appVersion = "app.version"
            case uuid = "device.id"
            case osVersion = "os.version"
            case deviceType = "device.type"
            case carrier = "device.carrier"
            case network = "device.network"
        }
        
        let details: OrderedDictionary<String, String> = [
            Keys.appVersion.rawValue: "1",
            Keys.uuid.rawValue: "123",
            Keys.osVersion.rawValue: "13",
            Keys.deviceType.rawValue:  "ios",
            Keys.carrier.rawValue: "apple",
            Keys.network.rawValue: "apple",
        ]
        let resource1 = Resource(from: details)
        let json = try! resource1.json()
        let resource2 = try! JSONDecoder().decode(Resource.self, from: json)
        
        XCTAssertEqual(resource1, resource2)
    }
    
    func testCompare_fails() {
        enum Keys: String, CodingKey {
            case appVersion = "app.version"
            case uuid = "device.id"
            case osVersion = "os.version"
            case deviceType = "device.type"
            case carrier = "device.carrier"
            case network = "device.network"
        }
        
        let details: OrderedDictionary<String, String> = [
            Keys.appVersion.rawValue: "1",
            Keys.uuid.rawValue: "123",
            Keys.osVersion.rawValue: "13",
            Keys.deviceType.rawValue:  "ios",
            Keys.carrier.rawValue: "apple",
            Keys.network.rawValue: "apple",
        ]
        let resource1 = Resource(from: details)
        let resource2 = Resource(from: [:])
        
        XCTAssertNotEqual(resource1, resource2)
    }
}

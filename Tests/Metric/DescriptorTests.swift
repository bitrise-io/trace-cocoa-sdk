//
//  DescriptorTests.swift
//  Tests
//
//  Created by Shams Ahmed on 17/06/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class DescriptorTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testDescriptor_createJSON() {
        let model = Metric.Descriptor(
            name: .appErrorTotal,
            description: "description",
            unit: .one,
            type: .int64,
            keys: [Metric.Descriptor.Key("myKey", description: "myKey")]
        )
        
        XCTAssertNotNil(model)
        XCTAssertNotNil(model.keys)
        XCTAssertEqual(model.keys.count, 1)
        
        let json = try? model.json()
        let jsonString = model.jsonString()
        
        XCTAssertNotNil(json)
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString?.contains("1") == true)
    }
    
    func testDescriptors_matchesJSON() {
        let model = Metric.Descriptor(
            name: .httpSessionConfiguration,
            description: "description",
            unit: .bytes,
            type: .int64,
            keys: [Metric.Descriptor.Key("myKey", description: "myKey")]
        )
        
        assertSnapshot(matching: model, as: .json)
    }
    
    func testDescriptors_mulipleKeys_matchesJSON() {
        let model = Metric.Descriptor(
            name: .systemCpuPct,
            description: "description",
            unit: .string,
            type: .int64,
            keys: [
                Metric.Descriptor.Key("myKey", description: "myKey"),
                Metric.Descriptor.Key("myKey1", description: "myKey1"),
                Metric.Descriptor.Key("myKey2", description: "myKey2"),
                Metric.Descriptor.Key("myKey3", description: "myKey3")
            ]
        )
        
        assertSnapshot(matching: model, as: .json)
    }
}

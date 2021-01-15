//
//  DuplicateKeysOfTypeTests.swift
//  Tests
//
//  Created by Shams Ahmed on 13/01/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class DuplicateKeysOfTypeTests: XCTestCase {
    
    // MARK: - Property
    
    var emptyResource: Resource { Resource(from: [:]) }
    var fullResource: Resource {
        Resource(from: [
            Resource.CodingKeys.Labels.appVersion.rawValue: "1.0.0",
            Resource.CodingKeys.Labels.buildVersion.rawValue: "100",
            Resource.CodingKeys.Labels.uuid.rawValue: "12345-ABCDE-12345-ABCDE-12345",
            Resource.CodingKeys.Labels.osVersion.rawValue: "14.1",
            Resource.CodingKeys.Labels.deviceType.rawValue: "iPhone",
            Resource.CodingKeys.Labels.platform.rawValue: "iOS",
            Resource.CodingKeys.Labels.carrier.rawValue: "EE",
            Resource.CodingKeys.Labels.network.rawValue: "Wifi",
            Resource.CodingKeys.Labels.sessionId.rawValue: "ABCDE-12345-ABCDE-12345-ABCDE",
            Resource.CodingKeys.Labels.jailbroken.rawValue: "false",
            Resource.CodingKeys.Labels.sdkVersion.rawValue: "1.0.0",
            Resource.CodingKeys.type.rawValue: "iOS",
            Resource.CodingKeys.labels.rawValue: "Unknown"
        ])
    }
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testGrouping() {
        let lists = ["Shams", "Richard", "Harry", "Slve"]
        let dict = Dictionary(grouping: lists) { $0.first! }
        
        XCTAssertEqual(dict.count, 3)
    }
    
    func testGrouping_duplicate() {
        let lists = ["Hello", "Hello", "Hello", "Hello"]
        let dict = Dictionary(grouping: lists) { $0.first! }
        
        XCTAssertEqual(dict.count, 1)
        XCTAssertEqual(dict.values.count, 1)
    }
    
    func testGrouping_withNilKey() {
        let lists = ["Hello", "Hello", "Hello", "Hello"]
        let dict = Dictionary(grouping: lists) { _ -> String? in nil }
        
        XCTAssertEqual(dict.count, 1)
        XCTAssertEqual(dict.values.count, 1)
    }
    
    func testGroupingTraces_withNilKey() {
        let traces = (0...1000)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGrouping10Traces_withKey() {
        let resource = emptyResource
        
        let traces = (0...10)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces.forEach { $0.resource = resource }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGrouping10Traces_withFullResourceKey() {
        let resource = fullResource
        
        let traces = (0...10)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces.forEach { $0.resource = resource }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGrouping1000Traces_withFullResourceKey() {
        let resource = fullResource
        
        let traces = (0...1000)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces.forEach { $0.resource = resource }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGrouping1000Traces_withRandomFullResourceKey() {
        let traces = (0...1000)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces.forEach { $0.resource = fullResource }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGrouping1000Traces_withKey() {
        let resource = emptyResource
        
        let traces = (0...1000)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces.forEach { $0.resource = resource }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGrouping1000Traces_withEvenKey() {
        let empty = emptyResource
        let full = fullResource
        
        let traces = (0...1000)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces.forEach { $0.resource = (Int.random(in: 1...8) % 2 == 0) ? empty : full }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 2)
    }
    
    func testGrouping100000Traces_withKey() {
        let resource = emptyResource
        
        let traces = (0...100000)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces.forEach { $0.resource = resource }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGrouping100000Traces_withFullResourceKey() {
        let resource = fullResource
        
        let traces = (0...100000)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces.forEach { $0.resource = resource }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGroupingTraces_withKeyAndDuplicateValues() {
        let resource = emptyResource
        let traces1 = (0...100)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        let traces2 = (0...100)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        
        let traces = traces1 + traces2
        traces.forEach { $0.resource = resource }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGroupingTraces_withFullResourceKeyAndDuplicateValues() {
        let resource = fullResource
        let traces1 = (0...100)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        let traces2 = (0...100)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        
        let traces = traces1 + traces2
        traces.forEach { $0.resource = resource }
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 1)
    }
    
    func testGroupingTraces_withFullResourceKeyAndDuplicateValues2() {
        let traces1Resource = fullResource
        let traces1 = (0...100)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces1.forEach { $0.resource = traces1Resource }
        
        let traces2Resource: Resource? = nil
        let traces2 = (0...100)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces2.forEach { $0.resource = traces2Resource }
        
        let traces3Resource = emptyResource
        let traces3 = (0...100)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces3.forEach { $0.resource = traces3Resource }
        
        let traces4Resource = fullResource
        let traces4 = (0...100)
            .map { $0 }
            .map { TraceModel.start(with: "\($0)", type: .view) }
        traces4.forEach { $0.resource = traces4Resource }
        
        let traces = traces1 + traces2
        
        
        let dict = Dictionary(grouping: traces) { $0.resource }
        
        XCTAssertEqual(dict.count, 2)
    }
}

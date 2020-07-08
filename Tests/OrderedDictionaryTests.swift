//
//  OrderedDictionaryTests.swift
//  Tests
//
//  Created by Shams Ahmed on 21/10/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class OrderedDictionaryTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testCount() {
        let dict: OrderedDictionary<String, String> = [
            "A": "One",
            "B": "2",
            "3": "Three",
            "D": "444"
        ]
        
        XCTAssertEqual(dict.count, 4)
        XCTAssertNotNil(dict.description)
    }
    
    func testRemove() {
        var dict: OrderedDictionary<String, String> = [
            "A": "One",
            "B": "2",
            "3": "Three",
            "D": "444",
            "E": "5"
            ,"F": "Six"
        ]
        dict.remove(at: 1)
        
        XCTAssertEqual(dict.count, 5)
        
        _ = dict.removeLast()
        
        XCTAssertEqual(dict.count, 4)
        
        _ = dict.removeFirst()
        
        XCTAssertEqual(dict.count, 3)
        
        dict.removeValue(forKey: "D")
        
        XCTAssertEqual(dict.count, 2)
        
        dict.removeAll()
        
        XCTAssertTrue(dict.isEmpty)
        XCTAssertEqual(dict.description, "[:]")
    }
    
    func testCodable() {
        let dict: OrderedDictionary<String, String> = [
            "A": "One",
            "B": "2",
            "3": "Three",
            "D": "444",
            "E": "5",
            "F": "Six"
        ]
        
        let json = try! dict.json()
        let string = dict.jsonString()!
        
        XCTAssertNotNil(json)
        XCTAssertGreaterThan(json.count, 1)
        XCTAssertNotNil(string)
        XCTAssertGreaterThan(string.count, 1)
        
        let model = try! JSONDecoder().decode(OrderedDictionary<String, String>.self, from: json)
        XCTAssertNotNil(model)
        XCTAssertEqual(model.count, 6)
        XCTAssertEqual(dict, model)
    }
    
    func testInsert() {
        var dict: OrderedDictionary<String, String> = [:]
        
        XCTAssertTrue(dict.isEmpty)
        
        dict.insert((key: "K", value: "V"), at: 0)
        
        XCTAssertFalse(dict.isEmpty)
    }
    
    func testIndex() {
        var dict: OrderedDictionary<String, String> = [:]
        dict.insert((key: "K", value: "V"), at: 0)
        
        XCTAssertNotNil(dict[0])
        XCTAssertNotNil(dict.value(forKey: "K"))
        XCTAssertNotNil(dict["K"])
    }
}

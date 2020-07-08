//
//  JSONEncodableTests.swift
//  Tests
//
//  Created by Shams Ahmed on 02/10/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation

import XCTest
@testable import Trace

struct MockModel: Encodable {
    let id, name, age: String
}

final class JSONEncodableTests: XCTestCase {
    
    // MARK: - Mock
    
    struct Mock: JSONEncodable {
       
        // MARK: - Property
        
        let name: String
        
        // MARK: - Details
        
        var details: OrderedDictionary<String, String> {
            return ["name": name]
        }
    }
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testJson() {
        let mock = Mock(name: "test")
        let json = mock.jsonString
        let hasName = json.contains("name")
        let hasTest = json.contains("test")
        
        XCTAssertFalse(mock.details.isEmpty)
        XCTAssertTrue(hasName)
        XCTAssertTrue(hasTest)
    }
    
    func testData() {
        let mock = Mock(name: "test")
        let data = String(data: mock.data!, encoding: .utf8)!
        let hasName = data.contains("name")
        let hasTest = data.contains("test")
        
        XCTAssertFalse(mock.details.isEmpty)
        XCTAssertTrue(hasName)
        XCTAssertTrue(hasTest)
    }
    
    func testDictionary() {
        let model = MockModel(id: "1", name: "shams", age: "100")
        
        do {
            let dictionary = try model.dictionary()
            
            XCTAssertNotNil(dictionary)
            XCTAssertEqual(dictionary.count, 3)
        } catch {
            XCTFail("json encoding error")
    
        }
    }
    
    func testDictionary_fails() {
        let model = [1, 2, 3]
        
        do {
            _ = try model.dictionary()
            
            XCTFail("json encoding error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}

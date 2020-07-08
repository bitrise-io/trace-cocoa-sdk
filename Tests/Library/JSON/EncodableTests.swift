//
//  EncodableTests.swift
//  Tests
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

struct Mock: Encodable, Decodable {
    let name: String
    let surname: String
}

struct FailMock: Encodable {
    let name: String
    let surname: String
    
    func encode(to encoder: Encoder) throws {
        throw Network.Error.invalidData
    }
}

final class EncodableTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testEncodeModel() {
        let model = Mock(name: "name", surname: "surname")
        
        XCTAssertNoThrow(try model.json())
        XCTAssertNotNil(model.jsonString())
    }
    
    func testFailsToEncodeModel() {
        let model = FailMock(name: "name", surname: "surname")
        
        XCTAssertThrowsError(try model.json())
        XCTAssertNil(model.jsonString())
    }
}

class DecodableTest: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    
    func testDecodeModelFails() {
        let model = try? JSONDecoder().decode(Mock.self, from: nil)
        
        XCTAssertNil(model)
    }
    
    func testDecodeModel() {
        let string = "{\"name\":\"name\", \"surname\":\"surname\"}"
        let data = string.data(using: String.Encoding.utf8)
        
        let model = try? JSONDecoder().decode(Mock.self, from: data)
        
        XCTAssertNotNil(model)
    }
}

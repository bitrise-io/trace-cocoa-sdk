//
//  DataTests.swift
//  Tests
//
//  Created by Shams Ahmed on 13/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class DataTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testAppendingStringToData() {
        var data = Data()
        data.appendString("test")
        
        let string = String(data: data, encoding: String.Encoding.utf8)!
        
        XCTAssertNotNil(data)
        XCTAssertNotNil(string)
        XCTAssertEqual(string, "test")
    }
    
    func testAppendingStringAgainToData() {
        var data = Data()
        data.appendString("test")
        data.appendString("again")
        
        let string = String(data: data, encoding: String.Encoding.utf8)!
        
        XCTAssertNotNil(data)
        XCTAssertNotNil(string)
        XCTAssertEqual(string, "testagain")
    }
    
    func testAppendingStringAgainToData2() {
        var data = Data()
        data.appendString("test")
        data.append(Data())
        data.appendString("again")
        
        let string = String(data: data, encoding: String.Encoding.utf8)!
        
        XCTAssertNotNil(data)
        XCTAssertNotNil(string)
        XCTAssertEqual(string, "testagain")
    }
}

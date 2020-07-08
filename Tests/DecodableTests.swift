//
//  DecodableTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/05/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class DecodableTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testDecodable_passes() {
        let dictionary = [
            "APM_COLLECTOR_TOKEN": "token",
            "APM_COLLECTOR_ENVIRONMENT": "https://bitrise.io"
        ]
        
        do {
            let model = try BitriseConfiguration(dictionary: dictionary)
            
            XCTAssertNotNil(model)
            XCTAssertEqual(model.token, "token")
            XCTAssertEqual(model.environment?.absoluteString, "https://bitrise.io")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDecodable_fails() {
        let dictionary = [String: String]()
        
        do {
            let model = try BitriseConfiguration(dictionary: dictionary)
            
            XCTAssertNil(model)
        } catch {
            // pass
        }
    }
}

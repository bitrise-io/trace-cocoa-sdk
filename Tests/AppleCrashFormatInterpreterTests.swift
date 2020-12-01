//
//  AppleCrashFormatInterpreterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 07/04/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class AppleCrashFormatInterpreterTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testFailsWithEmptyString() {
        let data = Data()
        let interpreter = AppleCrashFormatInterpreter(data)
        let result = interpreter.toModel()
        
        switch result {
        case .failure(let error):
            XCTAssertNotNil(error)
        default:
            XCTFail("test should fail with invalid data")
        }
        
        XCTAssertNotNil(result)
    }
    
    func testFindCrashFiles() {
        guard let url = Bundle(for: Self.self).url(forResource: "outOfBound", withExtension: "crash") else {
            return XCTFail("Could not locate test fails")
        }
        
        do {
            _ = try Data(contentsOf: url)
        } catch {
            XCTFail("Could not open crash file")
        }
    }
    
    func testCreateModel_outOfBound() {
        guard let url = Bundle(for: Self.self).url(forResource: "outOfBound", withExtension: "crash") else {
            return XCTFail("Could not locate test fails")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let interpreter = AppleCrashFormatInterpreter(data)
            let result = interpreter.toModel()
            
            XCTAssertNotNil(data)
            XCTAssertGreaterThan(data.count, 1)
            XCTAssertNotNil(interpreter)
            XCTAssertNotNil(result)
            
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(let model):
                XCTAssertNotNil(model)
                XCTAssertNotNil(model.id)
                XCTAssertNotNil(model.timestamp)
                XCTAssertFalse(model.id.isEmpty)
                XCTAssertFalse(model.timestamp.isEmpty)
                XCTAssertNotNil(model.appVersion)
                XCTAssertNotNil(model.buildVersion)
                XCTAssertNotNil(model.osVersion)
                XCTAssertTrue(!model.deviceType.isEmpty)
                XCTAssertNotNil(model.sessionId)
                XCTAssertTrue(!model.eventIdentifier.isEmpty)
                XCTAssertNotNil(model.network)
                XCTAssertNotNil(model.carrier)
                XCTAssertTrue(!model.deviceId.isEmpty)
                
                XCTAssertFalse(model.deviceType.contains("\""))
                XCTAssertFalse(model.network.contains("\""))
                XCTAssertFalse(model.carrier.contains("\""))
                XCTAssertFalse(model.deviceId.contains("\""))
            }
        } catch {
            XCTFail("Could not open crash file")
        }
    }
    
    func testCreateModel_noTraceId() {
        guard let url = Bundle(for: Self.self).url(forResource: "noTraceId", withExtension: "crash") else {
            return XCTFail("Could not locate test fails")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let interpreter = AppleCrashFormatInterpreter(data)
            let result = interpreter.toModel()
            
            XCTAssertNotNil(data)
            XCTAssertGreaterThan(data.count, 1)
            XCTAssertNotNil(interpreter)
            XCTAssertNotNil(result)
            
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(let model):
                XCTAssertNotNil(model)
                XCTAssertNotNil(model.id)
                XCTAssertNotNil(model.timestamp)
                XCTAssertFalse(model.timestamp.isEmpty)
                
                XCTAssertTrue(model.id.isEmpty)
            }
        } catch {
            XCTFail("Could not open crash file")
        }
    }
    
    func testCreateModel_traceIdEmpty() {
        guard let url = Bundle(for: Self.self).url(forResource: "traceIdEmpty", withExtension: "crash") else {
            return XCTFail("Could not locate test fails")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let interpreter = AppleCrashFormatInterpreter(data)
            let result = interpreter.toModel()
            
            XCTAssertNotNil(data)
            XCTAssertGreaterThan(data.count, 1)
            XCTAssertNotNil(interpreter)
            XCTAssertNotNil(result)
            
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(let model):
                XCTAssertNotNil(model)
                XCTAssertNotNil(model.id)
                XCTAssertNotNil(model.timestamp)
                XCTAssertFalse(model.timestamp.isEmpty)
                
                XCTAssertTrue(model.id.isEmpty)
            }
        } catch {
            XCTFail("Could not open crash file")
        }
    }
    
    func testCreateModel_InStringFormat() {
        guard let url = Bundle(for: Self.self).url(forResource: "traceIdEmpty", withExtension: "crash") else {
            return XCTFail("Could not locate test fails")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let string = String(data: data, encoding: .utf8)!
            
            XCTAssertNotNil(string)
            
            XCTAssertTrue(string.contains("SDK Event Identifier:"))
            XCTAssertTrue(string.contains("Build Version:"))
            XCTAssertTrue(string.contains("App Version:"))
            XCTAssertTrue(string.contains("app.session.id"))
        } catch {
            XCTFail("Could not open crash file")
        }
    }
}

//
//  CrashesServiceTests.swift
//  Tests
//
//  Created by Shams Ahmed on 10/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

import Foundation
import XCTest
@testable import Trace

final private class MockNetwork: Networkable {
    
    // MARK: - Enum
    
    enum Status {
        case success
        case failure
    }
    
    // MARK: - Property
    
    var status: Status = .success
    
    // MARK: - Network
    
    @discardableResult
    func request(_ request: Routable, _ completion: @escaping (MockNetwork.Completion) -> Void) -> URLSessionDataTask? {
        // call the callback
        switch status {
        case .success: completion(.success(nil))
        case .failure: completion(.failure(.invalidURL))
        }
        
        return URLSessionDataTask()
    }
    
    @discardableResult
    func upload(_ request: Routable, name: String, file: Data, parameters: [String: Any]?, _ completion: @escaping (Completion) -> Void) -> URLSessionDataTask? {
        // call the callback
        switch status {
        case .success: completion(.success(nil))
        case .failure: completion(.failure(.invalidURL))
        }
        
        return URLSessionDataTask()
    }
    
    // MARK: - Reset
    
    func reset() {
        // do nothing
    }
}

final class CrashesServiceTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testCreateObject() {
        let network = MockNetwork()
        let service = CrashesService(network: network)
        
        XCTAssertNotNil(service)
    }
    
    func testMock_success() {
        let network = MockNetwork()
        let service = CrashesService(network: network)
        let report = "Crash report here...".data(using: .utf8)!
        let model = Crash(id: "123", timestamp: "2020-03-11 16:35:29.357 +0000", title: "test", report: report)
        
        network.status = .success
        
        let task = service.crash(with: model) { result in
            switch result {
            case .success(let model):
                XCTAssertNil(model)
            case .failure:
                XCTFail("it should send request")
            }
        }
        
        XCTAssertNotNil(service)
        XCTAssertNotNil(task)
    }
    
    func testMock_fails() {
        let network = MockNetwork()
        let service = CrashesService(network: network)
        let report = "Crash report here...".data(using: .utf8)!
        let model = Crash(id: "123", timestamp: "2020-03-11 16:35:29.357 +0000", title: "test", report: report)
        
        network.status = .failure
        
        let task = service.crash(with: model) { result in
            switch result {
            case .success:
                XCTFail("it shouldn't send request")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        XCTAssertNotNil(service)
        XCTAssertNotNil(task)
    }
    
    func testRouter_createURL() {
        do {
            let crash = CrashesService.Router.crash
            let request = try crash.asURLRequest()
            
            XCTAssertNotNil(request)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

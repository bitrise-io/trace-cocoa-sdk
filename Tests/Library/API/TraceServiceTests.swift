//
//  TraceServiceTests.swift
//  Tests
//
//  Created by Shams Ahmed on 31/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

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
    func upload(_ request: Routable, name: String, file: Data, parameters: [String: Any]?, _ completion: @escaping (MockNetwork.Completion) -> Void) -> URLSessionDataTask? {
        // call the callback
        switch status {
        case .success: completion(.success(nil))
        case .failure: completion(.failure(.invalidURL))
        }
        
        return URLSessionDataTask()
    }
    
    // MARK: - Network
    
    func reset() {
        // do nothing
    }
}

final class TraceServiceTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testCreateObject() {
        let network = MockNetwork()
        let service = TraceService(network: network)
        
        XCTAssertNotNil(service)
    }
    
    func testMock_success() {
        let network = MockNetwork()
        let service = TraceService(network: network)
        let model = TraceModel(spans: [])
        
        network.status = .success
        
        let task = service.trace(with: model) { result in
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
        let service = TraceService(network: network)
        let model = TraceModel(spans: [])
        
        network.status = .failure
        
        let task = service.trace(with: model) { result in
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
}

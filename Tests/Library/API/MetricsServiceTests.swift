//
//  MetricsServiceTests.swift
//  Tests
//
//  Created by Shams Ahmed on 29/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

private final class MockNetwork: Networkable {
    
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
            case .success: completion(.success((data: nil, response: nil)))
        case .failure: completion(.failure(.invalidURL))
        }
        
        return URLSessionDataTask()
    }
    
    @discardableResult
    func upload(_ request: Routable, name: String, file: Data, parameters: [String: Any]?, _ completion: @escaping (MockNetwork.Completion) -> Void) -> URLSessionDataTask? {
        // call the callback
        switch status {
        case .success: completion(.success((data: nil, response: nil)))
        case .failure: completion(.failure(.invalidURL))
        }
        
        return URLSessionDataTask()
    }
    
    // MARK: - Reset
    
    func reset() {
        // do nothing
    }
}

final class MetricsServiceTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testCreateObject() {
        let network = MockNetwork()
        let service = MetricsService(network: network)
        
        XCTAssertNotNil(service)
    }
    
    func testMock_success() {
        let network = MockNetwork()
        let service = MetricsService(network: network)
        let metrics = Metrics([Metric]())
        
        network.status = .success
        
        let task = service.metrics(with: metrics) { result in
            switch result {
            case .success(let model):
                XCTAssertNil(model.data)
            case .failure:
                XCTFail("it should send request")
            }
        }
        
        XCTAssertNotNil(service)
        XCTAssertNotNil(task)
    }
    
    func testMock_fails() {
        let network = MockNetwork()
        let service = MetricsService(network: network)
        let metrics = Metrics([Metric]())
        
        network.status = .failure
        
        let task = service.metrics(with: metrics) { result in
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

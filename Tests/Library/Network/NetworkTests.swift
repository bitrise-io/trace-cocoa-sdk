//
//  NetworkTests.swift
//  Tests
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation

import XCTest
@testable import Trace

enum MockRouter: Routable {
    
    static var baseURL = URL(string: "https://httpstat.us/")!
    
    case empty
    case clientError
    case serverError
    case badURL
    
    var method: Network.Method { return .get }
    
    var path: String {
        switch self {
        case .badURL: return ""
        case .clientError: return "404"
        case .serverError: return "500"
        case .empty: return ""
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .empty, .clientError, .serverError:
            var url = MockRouter.baseURL
            url.appendPathComponent(path)
            
            let request = URLRequest(url: url)
            
            return request
        case .badURL:
            throw Network.Error.invalidURL
        }
    }
}

final class NetworkTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testConfiguration() {
        let configuration = Network.Configuration.default
        
        XCTAssertEqual(configuration.timeoutIntervalForRequest, 15.0)
        XCTAssertEqual(configuration.timeoutIntervalForResource, 15.0)
    }
    
    func testReset() {
        let network = Network()
        network.reset()
        
        // nothing here, if anything it would crash the whole test suite
    }
    
    func testMakingRequest_success() {
        let async = expectation(description: "network request success")
       
        let network = Network()
        network.authorization = "test"
        
        let task = network.request(MockRouter.empty) {
            switch $0 {
            case .success: async.fulfill()
            case .failure: XCTFail()
            }
        }
        
        waitForExpectations(timeout: 10.0) { _ in }
        
        _ = task
    }
    
    func testMakingRequest_clientError() {
        var task: URLSessionTask?
        let async = expectation(description: "network request clientError")
        
        let network = Network()
        network.authorization = "test"
        task = network.request(MockRouter.clientError) {
            switch $0 {
            case .success: XCTFail()
            case .failure: async.fulfill()
            }
        }
        
        XCTAssertNotNil(task)
        
        waitForExpectations(timeout: 10.0) { _ in }
        
        _ = task
    }
    
    func testMakingRequest_serverError() {
        let async = expectation(description: "network request serverError")
        
        let network = Network()
        network.authorization = "test"
        
        var task: URLSessionTask?
        task = network.request(MockRouter.serverError) {
            switch $0 {
            case .success: XCTFail()
            case .failure: async.fulfill()
            }
        }
        
        XCTAssertNotNil(task)
        
        waitForExpectations(timeout: 10.0) { _ in }
        
        _ = task
    }
    
    func testMakingRequest_failsWithAuth() {
        let async = expectation(description: "network request failsWithAuth")
        
        let network = Network()
        network.authorization = nil
        
        var task: URLSessionTask?
        task = network.request(MockRouter.empty) {
            switch $0 {
            case .success: XCTFail()
            case .failure: async.fulfill()
            }
        }
        
        XCTAssertNil(task)
        
        waitForExpectations(timeout: 10.0) { _ in }
        
        _ = task
    }
    
    func testMakingRequest_successWithConfiguration() {
        let async = expectation(description: "network request successWithConfiguration")
        
        let network = Network()
        network.configuration.additionalHeaders = [
            .authorization: "xxx"
        ]
        
        var task: URLSessionTask?
        task = network.request(MockRouter.empty) {
            switch $0 {
            case .success: async.fulfill()
            case .failure: XCTFail()
            }
        }
        
        waitForExpectations(timeout: 10.0) { _ in }
        
        XCTAssertNotNil(task)
        XCTAssertEqual(task?.originalRequest?.allHTTPHeaderFields?["Authorization"]!, "xxx")
        
        _ = task
    }
    
    func testMakingRequest_failureWithBadURL() {
        let async = expectation(description: "network request failureWithBadURL")
        var error: Error?
        
        let network = Network()
        let task = network.request(MockRouter.badURL) {
            switch $0 {
            case .success:
                XCTFail()
            case .failure(let newError):
                error = newError
                
                async.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10.0) { _ in }
        
        XCTAssertNotNil(error)
        XCTAssertNil(task)
        
        _ = task
    }
     
    func testMakingUpload_clientError() {
        var task: URLSessionTask?

        let async = expectation(description: "network request clientError")

        let network = Network()
        network.authorization = "test"
        
        task = network.upload(MockRouter.clientError, name: "test", file: Data()) {
            switch $0 {
            case .success: XCTFail()
            case .failure: async.fulfill()
            }
        }

        XCTAssertNotNil(task)

        waitForExpectations(timeout: 10.0) { _ in }

        _ = task
    }

    func testMakingUpload_serverError() {
        let async = expectation(description: "network request serverError")

        let network = Network()
        network.authorization = "test"

        var task: URLSessionTask?
        task = network.upload(MockRouter.serverError, name: "test", file: Data()) {
            switch $0 {
            case .success: XCTFail()
            case .failure: async.fulfill()
            }
        }

        XCTAssertNotNil(task)

        waitForExpectations(timeout: 10.0) { _ in }

        _ = task
    }

    func testMakingUpload_failsWithAuth() {
        let async = expectation(description: "network request failsWithAuth")

        let network = Network()
        network.authorization = nil

        var task: URLSessionTask?
        task = network.upload(MockRouter.empty, name: "test", file: Data()) {
            switch $0 {
            case .success: XCTFail()
            case .failure: async.fulfill()
            }
        }

        XCTAssertNil(task)

        waitForExpectations(timeout: 10.0) { _ in }

        _ = task
    }

    func testMakingUpload_failureWithBadURL() {
        let async = expectation(description: "network request failureWithBadURL")
        var error: Error?

        let network = Network()
        let task = network.upload(MockRouter.badURL, name: "test", file: Data()) {
            switch $0 {
            case .success:
                XCTFail()
            case .failure(let newError):
                error = newError

                async.fulfill()
            }
        }

        waitForExpectations(timeout: 10.0) { _ in }

        XCTAssertNotNil(error)
        XCTAssertNil(task)

        _ = task
    }
}

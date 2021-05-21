//
//  URLSessionTests.swift
//  Tests
//
//  Created by Shams Ahmed on 19/05/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

#if canImport(Combine)
import Combine
#endif

final class URLSessionTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        URLSession.bitrise_swizzle_methods()
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testDataRequest() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let reqest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: reqest)
        
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testDataURL() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let session = URLSession.shared
        let task = session.dataTask(with: url)
        
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testDataURL_cancel() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let session = URLSession.shared
        let task = session.dataTask(with: url)
        
        task.resume()
        task.cancel()
        
        switch task.state {
            case .running: XCTFail("Should be running the task")
            default: break
        }
    }
    
    func testDataURLCompletionHandler() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { _, _, _ in
            
        }
        
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testDataRequestCompletionHandler() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { _, _, _ in
            
        }
        
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testDataRequestCompletionHandler_cancel() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { _, _, _ in
            
        }
        
        task.resume()
        task.cancel()
        
        switch task.state {
            case .running: XCTFail("Should be running the task")
            default: break
        }
    }
    
    @available(iOS 13.0, *)
    func testDataRequestPublisher() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        var cancellables = [AnyCancellable]()
        let cancel1 = session.dataTaskPublisher(for: request).sink { (_) in
            
        } receiveValue: { (_) in

        }
        
        cancellables.append(cancel1)
    }
    
    @available(iOS 13.0, *)
    func testDataURLPublisher() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let session = URLSession.shared
        var cancellables = [AnyCancellable]()
        let cancel1 = session.dataTaskPublisher(for: url).sink { (_) in
            
        } receiveValue: { (_) in

        }
        
        cancellables.append(cancel1)
    }
    
    func testStreamNetService() throws {
        try XCTSkipIf(true, "crashes the test runner")
        
        URLSession.bitrise_swizzle_methods()
        
        let netService = NetService(
            domain: "local.",
            type: "_hap._tcp.",
            name: "test",
            port: 8000
        )
        let session = URLSession.shared
        let task = session.streamTask(with: netService)
        
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testStreamHost() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let session = URLSession.shared
        let task = session.streamTask(withHostName: url.absoluteString, port: 8000)
        
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testUploadData() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.uploadTask(with: request, from: Data())
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testUploadFiles_fails() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.uploadTask(with: request, fromFile: Bundle.main.bundleURL)
        task.resume()
        task.cancel()
        
        switch task.state {
            case .running: XCTFail("Should be running the task")
            default: break
        }
    }
    
    func testUploadDataCompletionHandler() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.uploadTask(with: request, from: Data()) { _, _, _ in
            
        }
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testUploadFileCompletionHandler() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.uploadTask(with: request, fromFile: Bundle.main
                                        .bundleURL) { _, _, _ in
            
        }
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testUploadFileStreamedRequest_fails() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.uploadTask(withStreamedRequest: request)
        task.resume()
        task.cancel()
        
        switch task.state {
            case .running: XCTFail("Should be running the task")
            default: break
        }
    }
    
    func testDownloadRequest() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.downloadTask(with: request)
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testDownloadURL() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let session = URLSession.shared
        let task = session.downloadTask(with: url)
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testDownloadRequestCompletionHandler() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.downloadTask(with: request) { _, _, _ in
            
        }
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testDownloadURLCompletionHandler() {
        URLSession.bitrise_swizzle_methods()
        
        let url = URL(string: "https://google.co.uk")!
        let session = URLSession.shared
        let task = session.downloadTask(with: url) { _, _, _ in
            
        }
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testDownloadResumeData() {
        URLSession.bitrise_swizzle_methods()
        
        let session = URLSession.shared
        
        let task = session.downloadTask(withResumeData: Data())
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testDownloadResumeDataCompletionHandler() {
        URLSession.bitrise_swizzle_methods()
        
        let session = URLSession.shared
        
        let task = session.downloadTask(withResumeData: Data()) { _, _, _ in
            
        }
        task.resume()
        
        switch task.state {
            case .running: break
            default: XCTFail("Should be running the task")
        }
    }
    
    func testInit() {
        URLSession.bitrise_swizzle_methods()
        
        let session = URLSession(configuration: .default)
    
        XCTAssertNotNil(session)
    }
    
    func testInitDelegate() {
        URLSession.bitrise_swizzle_methods()
        
        let session = URLSession(
            configuration: .ephemeral,
            delegate: nil,
            delegateQueue: .main
        )
        
        XCTAssertNotNil(session)
        XCTAssertEqual(session.delegateQueue, OperationQueue.main)
    }
}

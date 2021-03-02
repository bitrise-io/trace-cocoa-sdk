//
//  NetworkUploadViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 01/03/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import UIKit

/// Example of getting and sending data from network requests for upload tasks
final class NetworkUploadViewController: UIViewController {
    
    // MARK: - Property
    
    lazy var altSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        title = "Network (upload)"
        
        var url: URL {
            URL(string: "https://httpbin.org/post?randon=\(Int.random(in: 0..<100))")!
        }
        var request: URLRequest {
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            request.httpMethod = "POST"
            
            return request
        }
        
        let urlSession = URLSession.shared
        let data = url.dataRepresentation
        let fileURL = Bundle.main.url(forResource: "logo", withExtension: "png")!
        
        urlSession.uploadTask(with: request, from: data).resume()
        urlSession.uploadTask(with: request, fromFile: fileURL).resume()
        urlSession.uploadTask(with: request, from: data) { (_, _, _) in
            
        }.resume()
        urlSession.uploadTask(withStreamedRequest: request).resume()
        urlSession.uploadTask(with: request, fromFile: fileURL) { (_, _, _) in
            
        }.resume()
    }
}

extension NetworkUploadViewController: URLSessionDataDelegate {

    // MARK: - URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("DEMO - did finish collecting metrics delegate method called in Network class")
    }
}

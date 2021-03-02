
//
//  NetworkViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 22/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit
import Foundation
import Combine

/// Example of getting and sending data from network requests for data and download tasks
final class NetworkViewController: UIViewController {
    
    // MARK: - Property
    
    lazy var altSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNetwork()
        setupAltNetwork()
        setupAltNetworkWithQueue()
        setupDownloadRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
        setupNetwork()
        setupAltNetwork()
        setupAltNetworkWithQueue()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setup()
        setupNetwork()
        setupAltNetwork()
        setupAltNetworkWithQueue()
    }
    
    // MARK: - Setup
    
    private func setup() {
        title = "Network (data & download)"
        
        let shared = URLSession.shared
        let urls = [
            URL(string: "https://api.chucknorris.io/jokes/random")!,
            URL(string: "https://api.chucknorris.io/jokes/random?category=test")!,
            URL(string: "https://google.co.uk")!,
            URL(string: "https://bitrise.io")!,
            URL(string: "https://stackoverflow.com/")!,
            URL(string: "https://apm.bitrise.io")!,
            URL(string: "https://github.com")!
        ].map { url -> URLRequest in
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringCacheData
            
            return request
        }
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { _, _, _ in }
        
        var request = URLRequest(url: URL(string: "https://apple.com")!)
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpBody = "apples, apples, apples".data(using: .utf8)!
        
        // Test different type of request i.e download task
        shared.downloadTask(with: request).resume()
        
        // Test different type of request i.e data task
        urls.forEach {
            shared.dataTask(with: $0, completionHandler: completionHandler).resume()
        }
        
        // Test different type of request i.e upload task
        shared.uploadTask(with: request, from: Data()).resume()
        
        // check if SDK can capture error
        let error = NSError(domain: "test", code: 2, userInfo: nil)
        _ = error
    }
    
    private func setupAltNetwork() {
        let requests = [
            "https://httpstat.us/200",
            "https://httpstat.us/200?sleep=101",
            "https://httpstat.us/200?sleep=502",
            "https://httpstat.us/200?sleep=1001",
            "https://httpstat.us/200?sleep=2002",
            "https://httpstat.us/200?sleep=6003",
            "https://httpstat.us/200?sleep=2504",
            "https://httpstat.us/200?sleep=55",
            "https://httpstat.us/200",
            "https://httpstat.us/200?sleep=106",
            "https://httpstat.us/200?sleep=1507",
            "https://httpstat.us/200?sleep=1448"
        ]
        .compactMap { URL(string: $0) }
        .map { url -> URLRequest in
            var req = URLRequest(url: url)
            req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            
            return req
        }
        
        requests.forEach { [altSession] in
            altSession.dataTask(with: $0) { data, res, err in
                
            }
            
            altSession.dataTask(with: $0).resume()
        }
        
        DispatchQueue.global(qos: .background).async { [altSession] in
            requests.forEach {
                let waitingTime = Int.random(in: 1...4)
                
                sleep(UInt32(waitingTime))
                
                altSession.dataTask(with: $0) { data, res, err in
                    
                }
            }
        }
        
        if #available(iOS 13.0, *) {
            var cancellables = [AnyCancellable]()
            
            let cancel1 = URLSession.shared.dataTaskPublisher(for: requests[0]).sink { (_) in

            } receiveValue: { (_) in

            }
            let cancel2 = URLSession.shared.dataTaskPublisher(for: requests[0].url!).sink { (_) in

            } receiveValue: { (_) in

            }
            
            cancellables.append(cancel1)
            cancellables.append(cancel2)
        }
    }
    
    private func setupAltNetworkWithQueue() {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue())
        let requests = [
            "https://httpstat.us/200",
            "https://httpstat.us/200?sleep=111",
            "https://httpstat.us/200?sleep=512",
            "https://httpstat.us/200?sleep=1013",
            "https://httpstat.us/200?sleep=2014",
            "https://httpstat.us/200?sleep=6015",
            "https://httpstat.us/200?sleep=2516",
            "https://httpstat.us/200?sleep=517",
            "https://httpstat.us/200",
            "https://httpstat.us/200?sleep=118",
            "https://httpstat.us/200?sleep=1519",
            "https://httpstat.us/200?sleep=1320"
        ]
        .compactMap { URL(string: $0) }
        .map { url -> URLRequest in
            var req = URLRequest(url: url)
            req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            
            return req
        }
        
        requests.forEach {
            session.dataTask(with: $0) { data, res, err in
                
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            requests.forEach {
                let waitingTime = Int.random(in: 1...4)
                
                sleep(UInt32(waitingTime))
                
                session.dataTask(with: $0) { data, res, err in
                    
                }
            }
        }
    }
    
    private func setupNetwork() {
        let url1 = URL(string: "https://random-data-api.com/api/coffee/random_coffee")!
        
        var request1 = URLRequest(url: url1)
        request1.cachePolicy = .reloadIgnoringCacheData
        
        URLSession.shared.dataTask(with: request1) { data, req, err in
            
        }
        
        let url2 = URL(string: "https://random-data-api.com/api/code/random_code")!
        
        var request2 = URLRequest(url: url2)
        request2.cachePolicy = .reloadIgnoringCacheData
        
        var task1: URLSessionDataTask?
        task1 = URLSession.shared.dataTask(with: request2) { data, req, err in
            let url2 = URL(string: "https://random-data-api.com/api/code/random_code")!
            var request2 = URLRequest(url: url2)
            request2.cachePolicy = .reloadIgnoringCacheData
            
            URLSession.shared.dataTask(with: request2) { data, req, err in
                task1?.cancel()
                
                let url2 = URL(string: "https://random-data-api.com/api/code/random_code")!
                var request2 = URLRequest(url: url2)
                request2.cachePolicy = .reloadIgnoringCacheData
                
                URLSession.shared.dataTask(with: request2) { data, req, err in
                    URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                        URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                            URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                                URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        var task2: URLSessionDataTask?
        task2 = URLSession.shared.dataTask(with: request2) { data, req, err in
            URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                    task2 = URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                        URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                            
                            task2?.cancel()
                            
                            URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                                URLSession.shared.dataTask(with: URL(string: "https://random-data-api.com/api/code/random_code")!) { data, req, err in
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let url3 = URL(string: "https://random-data-api.com/api/lorem_ipsum/random_lorem_ipsum")!
        
        var request3 = URLRequest(url: url3)
        request3.cachePolicy = .reloadIgnoringCacheData
        
        URLSession.shared.dataTask(with: request3) { data, req, err in
            URLSession.shared.invalidateAndCancel()
        }
    }
    
    func setupDownloadRequest() {
        var url: URL {
            URL(string: "https://httpbin.org/image/jpeg?randon=\(Int.random(in: 0..<100))")!
        }
        var request: URLRequest {
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            
            return request
        }
        
        let urlSession = URLSession.shared
        
        urlSession.downloadTask(with: request).resume()
        
        let task1 = urlSession.downloadTask(with: url)
        task1.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            task1.cancel()
            
            if let response = task1.response as? HTTPURLResponse {
                print("Cancelled request detail: \(response)")
            }
        }
          
        urlSession.downloadTask(with: request) { (_, _, _) in
            
        }.resume()
        urlSession.downloadTask(with: url) { (_, _, _) in
            
        }.resume()
        
        let data = Data()

        urlSession.downloadTask(withResumeData: data).resume()
        urlSession.downloadTask(withResumeData: data) { (_, _, _) in

        }.resume()
    }
}

extension NetworkViewController: URLSessionDataDelegate {

    // MARK: - URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("DEMO - did finish collecting metrics delegate method called in Network class")
    }
}

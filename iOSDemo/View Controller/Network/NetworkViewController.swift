
//
//  NetworkViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 22/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit

/// Example of getting and sending data from network requests
final class NetworkViewController: UIViewController {
    
    // MARK: - Property
    
    lazy var altSession: URLSession = {
        return URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNetwork()
        setupAltNetwork()
        setupAltNetworkWithQueue()
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
        title = "Network"
        
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
            "https://httpstat.us/200?sleep=100",
            "https://httpstat.us/200?sleep=500",
            "https://httpstat.us/200?sleep=1000",
            "https://httpstat.us/200?sleep=2000",
            "https://httpstat.us/200?sleep=90000",
            "https://httpstat.us/200?sleep=2500",
            "https://httpstat.us/200?sleep=50",
            "https://httpstat.us/200",
            "https://httpstat.us/200?sleep=100",
            "https://httpstat.us/200?sleep=1500",
            "https://httpstat.us/200?sleep=10000"
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
        }
        
        DispatchQueue.global(qos: .background).async { [altSession] in
            requests.forEach {
                let waitingTime = Int.random(in: 1...4)
                
                sleep(UInt32(waitingTime))
                
                altSession.dataTask(with: $0) { data, res, err in
                    
                }
            }
        }
    }
    
    private func setupAltNetworkWithQueue() {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue())
        let requests = [
            "https://httpstat.us/200",
            "https://httpstat.us/200?sleep=100",
            "https://httpstat.us/200?sleep=500",
            "https://httpstat.us/200?sleep=1000",
            "https://httpstat.us/200?sleep=2000",
            "https://httpstat.us/200?sleep=90000",
            "https://httpstat.us/200?sleep=2500",
            "https://httpstat.us/200?sleep=50",
            "https://httpstat.us/200",
            "https://httpstat.us/200?sleep=100",
            "https://httpstat.us/200?sleep=1500",
            "https://httpstat.us/200?sleep=10000"
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
}

extension NetworkViewController: URLSessionDataDelegate {

    // MARK: - URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("DEMO - did finish collecting metrics delegate method called in Network class")
    }
}

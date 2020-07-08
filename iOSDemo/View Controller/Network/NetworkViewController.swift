
//
//  NetworkViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 22/08/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import UIKit

/// Example of getting and sending data from network requests
final class NetworkViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        ]
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
}

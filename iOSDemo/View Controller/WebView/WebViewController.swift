//
//  WebViewViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 16/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit
import WebKit

/// Example of getting data from Webview
final class WebViewController: UIViewController {
    
    // MARK: - Property
    
    private let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        
        return webView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup
    
    private func setup() {
        title = "Web View"
        
        view.addSubview(webView)
        
        let url = URL(string: "https://bitrise.io")!
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        // pre load website
        webView.navigationDelegate = self
        webView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate {
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("Demo - decidePolicyFor navigationResponse")
        
        _ = navigationResponse.canShowMIMEType
        _ = navigationResponse.isForMainFrame
        
        decisionHandler(.allow)
    }
}

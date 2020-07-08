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
    
    @IBOutlet private weak var webView: WKWebView!
    
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
        title = "Web View"
        
        let bitrise = URL(string: "https://bitrise.io")!
        
        // pre load website
        webView.load(URLRequest(url: bitrise))
    }
}

//
//  CrashViewController.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 22/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit

/// Example of crashing the app. Note must build app in Release mode
final class CrashViewController: UIViewController {
    
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
        
        crash()
    }
    
    // MARK: - Setup
    
    private func setup() {
        title = "Crash"
        
        // Random errors
        let error = NSError(domain: "test instance 1", code: 2, userInfo: nil)
        _ = error
        
        let error1 = NSError(domain: "test instance 2", code: 200, userInfo: nil)
        _ = error1
        
        let error2 = NSError(domain: "test instance 3", code: 200, userInfo: ["crash": "1"])
        _ = error2
    }
    
    // MARK: - Crash
    
    private func crash() {
        let list: NSArray = [1, 2, 3]
        
        print("Demo - testing fake crash")
        
        // force crash with out of bound
        _ = list[.max]
        
        print("Demo - This message shouldn't print!")
    }
}

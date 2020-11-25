//
//  AppDelegate.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit
import Trace

@UIApplicationMain
final class AppDelegate: UIResponder {

    // MARK: - Property

    internal var window: UIWindow?
    private var timer: Timer?
    
    // MARK: - Setup
    
    func setup() {
        timer = .scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in
            // Nothing fancy only used for running tests
        })
    }
}

//
//  AppDelegate.swift
//  iOSDemo
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit

#if DEBUG
// Should be addressed at somepoint:
// See more here: https://bugs.swift.org/browse/SR-3801
// and here: https://github.com/apple/swift/commit/08af6f0c0933dc70cb868633e2e017b63c12eba1
@testable import Trace
#else
import Trace
#endif

@UIApplicationMain
final class AppDelegate: UIResponder {

    // MARK: - Property

    internal var window: UIWindow?
    private var timer: Timer?
    
    // MARK: - Setup
    
    func setup() {
        timer = .scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in
            // nothing fancy used for running random tests
        })
    }
}

//
//  UIApplication+ViewController.swift
//  Trace
//
//  Created by Shams Ahmed on 27/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

/// Helper to find out the current view controller reguardless of view hierarchy type
internal extension UIApplication {
    
    // MARK: - Shared
    
    static var sharedIfAvailable: UIApplication? {
        let sharedSelector = NSSelectorFromString("sharedApplication")
        
        guard UIApplication.responds(to: sharedSelector) else { return nil }

        let shared = UIApplication.perform(sharedSelector)
        
        // swiftlint:disable force_cast
        return shared?.takeUnretainedValue() as! UIApplication?
        // swiftlint:enable force_cast
    }
    
    // MARK: - Window
    
    var currentWindow: UIWindow? {
        let application = UIApplication.sharedIfAvailable

        if #available(iOS 15.0, *) {
            return application?.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first(where: { $0.activationState == .foregroundActive })?.windows
                .first(where: { $0.isKeyWindow })
        }
        
        if #available(iOS 13.0, *) {
            return (application?.value(forKey: "windows") as? [UIWindow])?
                .first(where: { $0.isKeyWindow })
        } else {
            return application?.keyWindow
        }
    }
    
    // MARK: - View Controller
    
    func currentViewController(from viewController: UIViewController?) -> UIViewController? {
        guard let viewController = viewController else { return nil }
        
        if let viewController = viewController as? UINavigationController {
            if let viewController = viewController.visibleViewController {
                return currentViewController(from: viewController)
            } else {
                return currentViewController(from: viewController.topViewController)
            }
        } else if let viewController = viewController as? UITabBarController {
            if let viewControllers = viewController.viewControllers, viewControllers.count > 5, viewController.selectedIndex >= 4 {
                return currentViewController(from: viewController.moreNavigationController)
            } else {
                return currentViewController(from: viewController.selectedViewController)
            }
        } else if let viewController = viewController.presentedViewController {
            return currentViewController(from: viewController)
        } else if let children = viewController.children.first {
            return children
        } else {
            return viewController
        }
    }
}

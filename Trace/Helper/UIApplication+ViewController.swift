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
    
    // MARK: - View Controller
    
    func currentViewController(_ viewController: UIViewController? = shared.windows.first(where: { $0.isKeyWindow })?.rootViewController) -> UIViewController? {
        guard let viewController = viewController else { return nil }
        
        if let viewController = viewController as? UINavigationController {
            if let viewController = viewController.visibleViewController {
                return currentViewController(viewController)
            } else {
                return currentViewController(viewController.topViewController)
            }
        } else if let viewController = viewController as? UITabBarController {
            if let viewControllers = viewController.viewControllers, viewControllers.count > 5, viewController.selectedIndex >= 4 {
                return currentViewController(viewController.moreNavigationController)
            } else {
                return currentViewController(viewController.selectedViewController)
            }
        } else if let viewController = viewController.presentedViewController {
            return currentViewController(viewController)
        } else if let children = viewController.children.first {
            return children
        } else {
            return viewController
        }
    }
}

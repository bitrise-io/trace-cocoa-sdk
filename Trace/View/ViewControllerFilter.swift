//
//  ViewControllerFilter.swift
//  Trace
//
//  Created by Shams Ahmed on 16/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

internal extension UIViewController {
    
    // MARK: - Enum

    /// Not all views are useful from a tracing point of view.
    private enum Banned: String, CaseIterable {
        // Banned
        case UINavigationController
        case UITabBarController
        case UIInputWindowController
        case UISystemKeyboardDockController
        case UIZoomViewController
        case UISystemInputViewController
        case UISplitViewController
        case UICompatibilityInputViewController
        case UIStatusBarViewController
        case UIApplicationRotationFollowingControllerNoTouches
        case UIApplicationRotationFollowingController
        case UIEditingOverlayViewController
        case UISearchContainerViewController
        case UIKeyCommandDiscoverabilityHUDViewController
        case UIKeyboardCandidateGridCollectionViewController
        case UIPredictionViewController
        case UISystemInputAssistantViewController
        case UIActivityGroupViewController
        case UIInputViewAnimationControllerViewController
        case UIInputViewController
        case UIActivityViewController
        case UIAccessibilityLargeTextSegmentedViewController
        case UIPageViewController
        case FPUIActionExtensionViewController
        case ASCredentialProviderViewController
        case PKPaymentAuthorizationViewController
        case SFBrowserRemoteViewController
        case SFBrowserServiceViewController
        case SFReaderAppearanceMainViewController
        case SFReaderEnabledWebViewController
        case SFReaderViewController
        case SFWebViewController
        
        // Banned for MVP
        case UIPageController
        case UIAlertController
        case MSMessagesAppViewController
        case SKStoreProductViewController
        case CABTMIDICentralViewController
        case RPBroadcastActivityViewController
        case GKTurnBasedMatchmakerViewController
        case ILClassificationUIExtensionViewController
    }
    
    // MARK: - Internal
    
    /// Banned and internal classes are excluded
    var isInternalClass: Bool {
        let `class` = String(describing: type(of: self))
        
        return `class`.hasPrefix("_")
    }
    
    /// Banned and internal classes are excluded
    var isBannedClass: Bool {
        let `class` = String(describing: type(of: self))
        
        return Banned.allCases
            .map { $0.rawValue }
            .contains(`class`)
    }
}

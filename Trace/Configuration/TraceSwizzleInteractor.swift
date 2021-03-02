//
//  TraceSwizzleInteractor.swift
//  Trace
//
//  Created by Shams Ahmed on 11/08/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore.JSContextRef

internal struct TraceSwizzleInteractor {
    
    // MARK: - Setup
    
    @discardableResult
    static func setup() -> Bool {
        URLSessionTaskMetrics.bitrise_swizzle_methods()
        URLSession.bitrise_swizzle_methods()
        URLLocalSessionConnection.bitrise_swizzle_methods()
        LocalSessionTask.bitrise_swizzle_methods()
        
        UIViewController.bitrise_swizzle_methods()
        UIView.bitrise_swizzle_methods()
        
        // Disabled: only for prototyping
        // UIControl_Swizzled.bitrise_swizzle_methods()
        // UIGestureRecognizer.bitrise_swizzle_methods()
        
        NSError.bitrise_swizzle_methods()
        
        JSContext.bitrise_swizzle_methods()
        
        return true
    }
}

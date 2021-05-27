//
//  Exception+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 16/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

// MARK: - NSException

/// Internal use only
/// Disabled
extension NSException: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        // let `init` =
        _ = Selectors(
            original: #selector(NSException.init(name:reason:userInfo:)),
            alternative: #selector(NSException.init(bitriseName:reason:userInfo:))
        )
        
        // let raise =
        _ = Selectors(
            original: #selector(NSException.raise),
            alternative: #selector((NSException.bitrise_raise) as (NSException) -> () -> Void)
        )
        
        // let classRaise =
        _ = Selectors(
            original: #selector((NSException.raise(_:format:arguments:)) as (NSExceptionName, String, CVaListPointer) -> Void),
            alternative: #selector((NSException.raise(_:format:arguments:)) as (NSExceptionName, String, CVaListPointer) -> Void)
        )
        
        // Disabled
//        _ = self.swizzleInstanceMethod(`init`)
//        _ = self.swizzleInstanceMethod(raise)
        
        // Disabled: need to find a way to call static methods correctly
        // _ = self.swizzleClassMethod(classRaise.original, alternativeSelector: classRaise.alternative)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return .success
    }
    
    // MARK: - Init
    
    // Disabled
    @objc
    internal convenience init(bitriseName: NSExceptionName, reason: String?, userInfo: [AnyHashable: Any]?) {
        // call default method
        self.init(bitriseName: bitriseName, reason: reason, userInfo: userInfo)
    }
    
    // Disabled: need to find a way to call static methods correctly
    // pecker:ignore
    internal static func bitrise_raise(name: NSExceptionName, format: String, arguments: CVaListPointer) {
        // call default method
        // self.bitrise_raise(name: name, format: format, arguments: arguments)
    }
    
    // MARK: - Raise
    
    @objc
    internal func bitrise_raise() {
        // call default method
        self.bitrise_raise()
    }
}

//
//  JSValue+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 17/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

#if canImport(JavaScriptCore)
import JavaScriptCore
#endif

/// Internal use only
/// Disabled
extension JSValue: Swizzled {
    
    // MARK: - Swizzled
    
    // pecker:ignore
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        let `init` = Selectors(
            original: #selector(JSValue.init(newErrorFromMessage:in:)),
            alternative: #selector(JSValue.init(bitrise_newErrorFromMessage:in:))
        )
        let null = Selectors(
            original: #selector(JSValue.init(nullIn:)),
            alternative: #selector(JSValue.init(bitrise_nullIn:))
        )
        let undefined = Selectors(
            original: #selector(JSValue.init(undefinedIn:)),
            alternative: #selector(JSValue.init(bitrise_undefinedIn:))
        )
        let regularExpression = Selectors(
            original: #selector(JSValue.init(newRegularExpressionFromPattern:flags:in:)),
            alternative: #selector(JSValue.init(bitrise_newRegularExpressionFromPattern:flags:in:))
        )
        let array = Selectors(
            original: #selector(JSValue.init(newArrayIn:)),
            alternative: #selector(JSValue.init(bitrise_newArrayIn:))
        )
        let newObject = Selectors(
            original: #selector(JSValue.init(newObjectIn:)),
            alternative: #selector(JSValue.init(bitrise_newObjectIn:))
        )
        let object = Selectors(
            original: #selector(JSValue.init(object:in:)),
            alternative: #selector(JSValue.init(bitrise_object:in:))
        )
        
        _ = self.swizzleInstanceMethod(`init`)
        _ = self.swizzleInstanceMethod(null)
        _ = self.swizzleInstanceMethod(undefined)
        _ = self.swizzleInstanceMethod(regularExpression)
        _ = self.swizzleInstanceMethod(array)
        _ = self.swizzleInstanceMethod(newObject)
        _ = self.swizzleInstanceMethod(object)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return .success
    }
    
    // MARK: - Init
    
    @objc
    convenience init(bitrise_newErrorFromMessage message: String, in context: JSContext) {
        self.init(bitrise_newErrorFromMessage: message, in: context)
    }
    
    @objc
    convenience init(bitrise_nullIn context: JSContext) {
        self.init(bitrise_nullIn: context)
    }
    
    @objc
    convenience init(bitrise_undefinedIn context: JSContext) {
        self.init(bitrise_undefinedIn: context)
    }
    
    @objc
    convenience init(bitrise_newRegularExpressionFromPattern pattern: String, flags: String, in context: JSContext) {
        self.init(bitrise_newRegularExpressionFromPattern: pattern, flags: flags, in: context)
    }
    
    @objc
    convenience init(bitrise_newArrayIn context: JSContext) {
        self.init(bitrise_newArrayIn: context)
    }
    
    @objc
    convenience init(bitrise_newObjectIn context: JSContext) {
        self.init(bitrise_newObjectIn: context)
    }
    
    @objc
    convenience init(bitrise_object value: Any, in context: JSContext) {
        self.init(bitrise_object: value, in: context)
    }
}

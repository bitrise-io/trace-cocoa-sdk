//
//  JSContext+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 17/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import JavaScriptCore

/// Internal use only
internal extension JSContext {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let getter = Selectors(
            original: #selector(getter: JSContext.exceptionHandler),
            alternative: #selector(getter: JSContext.bitrise_exceptionHandler)
        )
        
        return self.swizzleInstanceMethod(getter)
    }
    
    // MARK: - Typealias
    
    typealias ExceptionHandler = ((JSContext?, JSValue?) -> Void)
    
    // MARK: - Enum
    
    private struct AssociatedKey {
        static var newExceptionHandler = "br_context_newExceptionHandler"
    }
    
    // MARK: - Property
    
    private var newExceptionHandler: ExceptionHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.newExceptionHandler) as? ExceptionHandler
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.newExceptionHandler, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - Exception Handler
    
    @objc
    var bitrise_exceptionHandler: ExceptionHandler! {
        let oldHandler = self.bitrise_exceptionHandler
        
        newExceptionHandler = { [weak self] context, value in
            oldHandler?(context, value)
        
            self?.process(value)
        }
        
        return newExceptionHandler
    }
    
    // MARK: - Process
    
    private func process(_ value: JSValue?) {
        var error = [String: String]()
        
        value?.toDictionary()?.forEach { key, value in
            if let key = key as? String {
                error[key] = "\(value)"
            }
        }
        
        let formatter = ErrorFormatter(
            domain: "Javascript exception",
            code: -1,
            userinfo: ["userinfo": value?.toString() ?? ""],
            metadata: error
        )
        
        Trace.shared.queue.add(formatter.metrics)
    }
}

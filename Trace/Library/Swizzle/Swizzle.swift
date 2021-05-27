//
//  Swizzle.swift
//  Trace
//
//  Created by Shams Ahmed on 23/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import ObjectiveC

internal typealias Selectors = (
    original: Selector,
    alternative: Selector
)

internal typealias SelectorWithType = (
    selector: Selector,
    `class`: AnyClass
)

internal protocol Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result
    
    // MARK: - Stacktrace - Trace
    
    static func BITRISE_WILL_SWIZZLE_METHOD()
    static func BITRISE_DID_SWIZZLE_METHOD()
}

extension Swizzled {
    
    // MARK: - Stacktrace - Trace
    
    static func BITRISE_WILL_SWIZZLE_METHOD() {
        
    }
    
    static func BITRISE_DID_SWIZZLE_METHOD() {
        
    }
}

/// Helper for swizzling objects
internal extension NSObject {
    
    // MARK: - Swizzle
    
    @discardableResult
    class func swizzleInstanceMethod(_ selectors: Selectors) -> Swizzle.Result {
        let alternative = Swizzle.Object(class: self.classForCoder(), selector: selectors.alternative)
        
        return self.attemptSwizzle(with: selectors.original, alternative: alternative, isClass: false)
    }
    
    @discardableResult
    class func swizzleInstanceMethod(_ selector: Selector, for alternativeSelector: Selector) -> Swizzle.Result {
        let alternative = Swizzle.Object(class: self.classForCoder(), selector: alternativeSelector)
        
        return self.attemptSwizzle(with: selector, alternative: alternative, isClass: false)
    }
    
    @discardableResult
    class func swizzleInstanceMethod(_ selector: Selector, for alternative: Swizzle.Object) -> Swizzle.Result {
        return self.attemptSwizzle(with: selector, alternative: alternative, isClass: false)
    }
    
    @discardableResult
    class func swizzleClassMethod(_ selector: Selector, alternativeSelector: Selector) -> Swizzle.Result {
        let alternative = Swizzle.Object(class: self.classForCoder(), selector: alternativeSelector)
        
        return self.attemptSwizzle(with: selector, alternative: alternative, isClass: true)
    }
    
    @discardableResult
    class func swizzleClassMethod(_ selector: Selector, for alternative: Swizzle.Object) -> Swizzle.Result {
        return self.attemptSwizzle(with: selector, alternative: alternative, isClass: true)
    }

    // MARK: - Private
    
    private class func attemptSwizzle(with originalSelector: Selector, alternative: Swizzle.Object, isClass: Bool) -> Swizzle.Result {
        var alternative = alternative
        var originalClass: AnyClass = classForCoder()
        
        if isClass {
            guard let foundClass = object_getClass(alternative.class) else { return .alternativeMethodNotFound }
            
            alternative.class = foundClass
            
            guard let _class = object_getClass(classForCoder()) else { return .originalMethodNotFound }
            
            originalClass = _class
        }
        
        let originalObject = Swizzle.Object(class: originalClass, selector: originalSelector)
        
        return Swizzle.method(for: originalObject, with: alternative)
    }
}

// MARK: - Swizzle

internal class Swizzle {
    
    // MARK: - Typealias
    
    typealias Object = (class: AnyClass, selector: Selector)
    
    // MARK: - Enum
    
    enum Result {
        case success
        case failure
        case originalMethodNotFound
        case alternativeMethodNotFound
    }
    
    // MARK: - Swizzle
    
    internal static func method(for original: Swizzle.Object, with alternative: Swizzle.Object) -> Swizzle.Result {
        guard let originalMethod = class_getInstanceMethod(original.class, original.selector) else {
            return .originalMethodNotFound
        }
        guard let alternativeMethod = class_getInstanceMethod(alternative.class, alternative.selector) else {
            return .alternativeMethodNotFound
        }
        
        _ = class_addMethod(
            original.class,
            original.selector,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod)
        )
        _ = class_addMethod(
            alternative.class,
            alternative.selector,
            method_getImplementation(alternativeMethod),
            method_getTypeEncoding(alternativeMethod)
        )
        
        method_exchangeImplementations(originalMethod, alternativeMethod)
        
        return .success
    }
    
    /**
     typealias NewClosureType =  @convention(c) (AnyObject, Selector, AnyObject?) -> Void
     
     let originalImp: IMP = method_getImplementation(method)
     let block: @convention(block) (AnyObject, AnyObject?) -> Void = { (me, error) in
         // call the original
         let original: NewClosureType = unsafeBitCast(originalImp, to: NewClosureType.self)
         original(me, selector, error)
         
         // your code here
     }
     **/
    @discardableResult
    func block(_ block: Any, forMethod method: Method) -> IMP {
        method_setImplementation(method, imp_implementationWithBlock(block))
    }
}

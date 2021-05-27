//
//  LocalSessionTask.swift
//  Trace
//
//  Created by Shams Ahmed on 26/02/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation

final class LocalSessionTask: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        // In iOS 14 resume method is inside NSURLSessionTask class
        var baseResumeClass: AnyClass? = URLSessionTask.self
        
        #if !targetEnvironment(macCatalyst)
        // In iOS 9 resume method inside __NSCFURLSessionTask
        // SDK min support is iOS 10
        if ProcessInfo.processInfo.operatingSystemVersion.majorVersion < 14 {
            let part4 = "CF"
            let part5 = "URL"
            let part1 = "__"
            let part3 = ""
            let part8 = "Task"
            let part6 = "Session"
            let part2 = "NS"
            let part7 = ""
            let section1 = part1 + part2 + part3
            let section3 = part7 + part8
            let section2 = part4 + part5 + part6
            
            baseResumeClass = NSClassFromString(section1 + section2 + section3)
        }
        #endif
    
        guard let `class` = baseResumeClass else {
            Logger.error(.network, "Could not find URLSessionTask")
            
            return .failure
        }
        
        let key = "resume"
        let selector = NSSelectorFromString(key)
        
        guard let method = class_getInstanceMethod(`class`, selector),
            `class`.instancesRespond(to: selector) else {
            return .originalMethodNotFound
        }

        typealias ClosureType =  @convention(c) (AnyObject, Selector) -> Void

        let originalImp: IMP = method_getImplementation(method)
        let block: @convention(block) (AnyObject) -> Void = { current in
            // call original
            let original: ClosureType = unsafeBitCast(originalImp, to: ClosureType.self)
            original(current, selector)

            // Validate
            if let task = current as? URLSessionTask {
                process(task)
            } else {
                Logger.error(.network, "Failed to call .resume method")
            }
        }
        
        // Run
        Swizzle().block(block, forMethod: method)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return .success
    }
    
    // MARK: - Private
    
    private static func process(_ task: URLSessionTask) {
        let timestamp = Time.timestamp
        let api = Constants.API.absoluteString

        guard task.currentRequest?.url?.absoluteString.contains(api) == false || task.originalRequest?.url?.absoluteString.contains(api) == false else {
            return
        }
        
        if task.startDate == nil {
            task.startDate = timestamp
        } else {
            Logger.debug(.network, "Start date has already been set for request: \(task.currentRequest?.url?.absoluteString ?? "Unknown")")
        }
    }
}

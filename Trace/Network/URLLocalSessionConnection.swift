//
//  URLLocalSessionConnection.swift
//  Trace
//
//  Created by Shams Ahmed on 26/02/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation

final class URLLocalSessionConnection: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        let part7 = "Connection"
        let part4 = "URL"
        let part5 = "Local"
        let part1 = "__"
        let part3 = "CF"
        let part6 = "Session"
        let part2 = "NS"
        let section1 = part1 + part2 + part3
        let section3 = part6 + part7
        let section2 = part4 + part5
        
        // Delegate
        // iOS 9, 10, 11, 12, 13, 14 class: __NSCFURLLocalSessionConnection
        guard let `class` = NSClassFromString(section1 + section2 + section3) else {
            return .failure
        }
        
        let methodPart5 = "With"
        let methodPart3 = ""
        let methodPart2 = "did"
        let methodPart7 = ":"
        let methodPart1 = "_"
        let methodPart4 = "Finish"
        let methodPart6 = "Error"
        let methodSection2 = methodPart4 + methodPart5
        let methodSection1 = methodPart1 + methodPart2 + methodPart3
        let methodSection3 = methodPart6 + methodPart7
        let selector = NSSelectorFromString(methodSection1 + methodSection2 + methodSection3)
        
        // method: _didFinishWithError:
        guard let method = class_getInstanceMethod(`class`, selector), `class`.instancesRespond(to: selector) else {
            return .failure
        }
        
        typealias ClosureType = @convention(c) (AnyObject, Selector, AnyObject?) -> Void
        
        let originalImp: IMP = method_getImplementation(method)
        let block: @convention(block) (AnyObject, AnyObject?) -> Void = { current, error in
            // call original
            let original: ClosureType = unsafeBitCast(originalImp, to: ClosureType.self)
            original(current, selector, error)
            
            let key = "task"
            
            // Validate
            if let task = current.value(forKey: key) as? URLSessionTask {
                process(task)
            } else {
                Logger.error(.network, "Failed to get data for did Finish With Error method")
            }
        }
        
        // Run
        Swizzle().block(block, forMethod: method)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return .success
    }
    
    // MARK: - Private
    
    private static func process(_ task: URLSessionTask) {
        let api = Constants.API.absoluteString
        
        guard task.currentRequest?.url?.absoluteString.contains(api) == false || task.originalRequest?.url?.absoluteString.contains(api) == false else {
            return
        }
        
        let timestamp = Time.timestamp
        
        switch task.state {
        case .running, .completed:
            if task.endDate == nil {
                task.endDate = timestamp
            }

            // Used when task metric is not enabled
            let formatter = URLSessionTaskFormatter(task)
            let spans = formatter.spans

            let shared = Trace.shared
            shared.tracer.addChild(spans)
            shared.queue.add(formatter.metrics, force: false, delay: true)

            // some odd reason, this object get freed up and crashes the app, so i made sure it stay in memory a little longer by holding on to it after using it above to stop it crashing.
            _ = spans
        case .canceling, .suspended:
            task.startDate = nil
            task.endDate = nil
        @unknown default:
            break
        }
    }
}

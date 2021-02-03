//
//  Error+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 15/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

// MARK: - NSError

/// Internal use only
extension NSError: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let `init` = Selectors(
            original: #selector(NSError.init(domain:code:userInfo:)),
            alternative: #selector(NSError.init(bitriseDomain:code:userInfo:))
        )
        
        return self.swizzleInstanceMethod(`init`)
    }
    
    // MARK: - Init
    
    @objc
    internal convenience init(bitriseDomain: String, code: Int, userInfo: [String: Any]?) {
        // this crashes if i send it without in a queue
        DispatchQueue.main.async {
            NSError.process(domain: bitriseDomain, code: code, userInfo: userInfo)
        }
        
        // call default method
        self.init(bitriseDomain: bitriseDomain, code: code, userInfo: userInfo)
    }
    
    // MARK: - Process
    
    private static func process(domain: String, code: Int, userInfo: [String: Any]?) {
        let formatter = ErrorFormatter(domain: domain, code: code, userinfo: userInfo)
        let key = Constants.API.absoluteString
        let failingURLKey = (userInfo?["NSErrorFailingURLKey"] as? String) ?? ""
        let failingURLStringKey = (userInfo?["NSErrorFailingURLStringKey"] as? String) ?? ""
        
        guard !domain.contains("bitrise") else { return }
        guard !failingURLKey.contains(key) || !failingURLStringKey.contains(key) else {
            return
        }
        
        Trace.shared.queue.add(formatter.metrics)
    }
}

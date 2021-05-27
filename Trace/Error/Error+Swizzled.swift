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
        BITRISE_WILL_SWIZZLE_METHOD()
        
        let `init` = Selectors(
            original: #selector(NSError.init(domain:code:userInfo:)),
            alternative: #selector(NSError.init(bitriseDomain:code:userInfo:))
        )
        
        let result = self.swizzleInstanceMethod(`init`)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return result
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
        guard !domain.lowercased().contains("bitrise") else { return }
        
        let key = Constants.API.absoluteString
        let failingURLKey = (userInfo?["NSErrorFailingURLKey"] as? String) ?? ""
        let failingURLStringKey = (userInfo?["NSErrorFailingURLStringKey"] as? String) ?? ""
        
        guard !failingURLKey.contains(key) || !failingURLStringKey.contains(key) else {
            return
        }
        
        let formatter = ErrorFormatter(domain: domain, code: code, userinfo: userInfo)
        
        Trace.shared.queue.add(formatter.metrics)
    }
}

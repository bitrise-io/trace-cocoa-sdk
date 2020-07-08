//
//  Configuration.swift
//  Trace
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation

/// Configuration can only be set once
@objcMembers
@objc(BRConfiguration)
public final class Configuration: NSObject {
    
    // MARK: - Static Property
    
    /// Default configuration
    public static let `default`: Configuration = Configuration()
    
    // MARK: - Property
    
    /// debug logs
    public var logs: Bool = true
    
    // MARK: - Init
    
    private override init() {
        super.init()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
}

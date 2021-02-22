//
//  Configuration.swift
//  Trace
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
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
    
    /// Enabled Trace. This does not do anything after SDK has started up
    public var enabled: Bool = true {
        didSet {
            Logger.debug(.application, "Configuration.enabled has been set to \(enabled)")
            
            if enabled {
                Logger.warning(.launch, "Call Swift: `Trace.shared` or Objective-c: `BRTrace.shared` method to start the SDK")
            }
        }
    }
    
    /// Log level, by default set to .warning / BRLoggerLevelWarning while in beta
    public var log: LoggerLevel = .warning
    
    // MARK: - Init
    
    private override init() {
        super.init()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
}

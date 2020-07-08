//
//  Log.swift
//  Trace
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Logger
internal enum Logger {
    
    // MARK: - Enum
    
    internal enum Module: String {
        case launch
        case application
        case cpu
        case memory
        case internalError
        case network
        case serialization
        case queue
        case scheduler
        case crash
        case database
        case fps
        case traceModel
        case prototype
    }
    
    // MARK: - Validation
    
    private static func isAllowedWhenDisabled(for module: Module) -> Bool {
        return module == .crash || module == .launch || module == .internalError
    }
    
    // MARK: - Log
    
    /// Print console log
    ///
    /// - Parameters:
    ///   - module: module type
    ///   - message: message to print
    @discardableResult
    internal static func print(_ module: Module, _ message: String) -> Bool {
        guard Trace.configuration.logs || isAllowedWhenDisabled(for: module) else { return false }
        
        // Add prefix to all logs
        let prefix = "[\(Constants.SDK.company.rawValue):" + Constants.SDK.name.rawValue + "/"
        let text = prefix + module.rawValue + "]" + " " + message
        
        Swift.print(text)
        
        return true
    }
    
    /// Print console log
    ///
    /// - Parameters:
    ///   - module: module type
    ///   - object: object to print
    @discardableResult
    internal static func print(_ module: Module, _ object: Any) -> Bool {
        guard Trace.configuration.logs || isAllowedWhenDisabled(for: module) else { return false }
        
        // Add prefix to all logs
        let prefix = "[\(Constants.SDK.company.rawValue):" + Constants.SDK.name.rawValue + "/"
        let text = prefix + module.rawValue + "]" + " \(object)"
        
        Swift.print(text)
        
        return true
    }
}

/// Internal use only
// pecker:ignore
@objc(BRLoggerObjc)
@objcMembers
internal final class LoggerObjc: NSObject {
    
    // MARK: - Print
    
    /// :nodoc:
    // pecker:ignore
    @discardableResult
    static func print(_ message: String, for rawModule: String) -> Bool {
        // This method exposes Swift method to Objective-c since it doesn't support raw enum with string type
        guard let module = Logger.Module(rawValue: rawModule) else {
            Logger.print(.internalError, "Failed to map module using key: \(rawModule)")
            
            return false
        }
        
        return Logger.print(module, message)
    }
}

//
//  Log.swift
//  Trace
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Logger level
@objc(BRLoggerLevel)
public enum LoggerLevel: Int, Comparable {
    
    // MARK: - Case
    
    case debug = 0
    case `default` = 1
    case warning = 2
    case error = 3
    
    // MARK: - Comparable
    
    static public func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    static public func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }

    static public func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }

    static public func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
}

/// Logger
public enum Logger {
    
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
    
    // MARK: - Log
    
    @discardableResult
    internal static func debug(_ module: Module, _ message: String) -> Bool {
        guard LoggerLevel.debug >= Trace.configuration.log else { return false }
        
        return Logger.print(module, message)
    }
    
    @discardableResult
    internal static func debug(_ module: Module, _ object: Any) -> Bool {
        guard LoggerLevel.debug >= Trace.configuration.log else { return false }
        
        return Logger.print(module, object)
    }
    
    @discardableResult
    internal static func `default`(_ module: Module, _ message: String) -> Bool {
        guard LoggerLevel.default >= Trace.configuration.log else { return false }
        
        return Logger.print(module, message)
    }
    
    @discardableResult
    internal static func `default`(_ module: Module, _ object: Any) -> Bool {
        guard LoggerLevel.default >= Trace.configuration.log else { return false }
        
        return Logger.print(module, object)
    }
    
    @discardableResult
    internal static func warning(_ module: Module, _ message: String) -> Bool {
        guard LoggerLevel.warning >= Trace.configuration.log else { return false }
        
        return Logger.print(module, message)
    }
    
    @discardableResult
    internal static func error(_ module: Module, _ message: String) -> Bool {
        return Logger.print(module, message)
    }
    
    // MARK: - Print
    
    /// Print console log
    ///
    /// - Parameters:
    ///   - module: module type
    ///   - message: message to print
    @discardableResult
    internal static func print(_ module: Module, _ message: String) -> Bool {
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
    fileprivate static func print(_ module: Module, _ object: Any) -> Bool {
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
            Logger.error(.internalError, "Failed to map module using key: \(rawModule)")
            
            return false
        }
        
        return Logger.print(module, message)
    }
}

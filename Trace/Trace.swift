//
//  Trace.swift
//  Trace
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore.JSContextRef

/// Trace SDK
@objcMembers
@objc(BRTrace)
final public class Trace: NSObject {
    
    // MARK: - Static Property
    
    /// Shared instance
    public static let shared: Trace = Trace()
    
    /// Configuration
    public static var configuration: Configuration = .default
    
    /// :nodoc:
    internal private(set) static var currentSession: CFTimeInterval = 0.0
    
    // MARK: - Property
    
    /**
     Attributes for all metric's events.
     For example emails, username, name, id, gender etc...
    */
    public var attributes: [String: String] = [:]
    
    // MARK: - Property - Internal
    
    private let network: Network
    internal let queue: Queue
    internal let database: Database
    private let lifecycle: Lifecycle
    private let session: Session
    private let fps: FPS
    private let scheduler: Scheduler
    
    /// Crash controller
    public let crash: CrashController
    
    internal let tracer: Tracer
    
    // MARK: - Init
    
    private override init() {
        network = Network()
        database = Database()
        session = Session()
        
        scheduler = Scheduler(with: network)
        queue = Queue(with: scheduler, database, session) // make sure queue startup first
        
        lifecycle = Lifecycle()
        tracer = Tracer(with: queue, session)
        crash = CrashController(with: scheduler)
        
        fps = FPS()
        
        super.init()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        Logger.print(.launch, "Bitrise Trace \(Constants.SDK.version.rawValue)")
        
        setupConfiguration()
        setupCrashReporting()
        setupSwizzle()
    }
    
    private func setupConfiguration() {
        do {
            // Check configuration file
            let configuration = try BitriseConfigurationInteractor()
            network.authorization = configuration.model.token
            
            if let environment = configuration.model.environment {
                Constants.API = environment
            }
        } catch {
            Logger.print(.internalError, "Application failed to read configuration file, all data will be cached until it's resolved")
        }
        
        // Check XCode environment variables. this only works when running with a debugger i.e in Run app or Tests
        let environment = ProcessInfo.processInfo.environment
        
        if let configuration = try? BitriseConfiguration(dictionary: environment) {
            Logger.print(.application, "Overriding configuration from Xcode environment variables")
                
            network.authorization = configuration.token
            
            if let api = configuration.environment {
                Constants.API = api
            }
        }
    }
    
    private func setupCrashReporting() {
        CrashReporting.observe()
        
        crash.setup()
    }
    
    private func setupSwizzle() {
        URLSessionTaskMetrics.bitrise_swizzle_methods()
        URLSession.bitrise_swizzle_methods()
        
        UIViewController.bitrise_swizzle_methods()
        UIView.bitrise_swizzle_methods()
        
        // Disabled: only for prototyping
        // UIControl_Swizzled.bitrise_swizzle_methods()
        // UIGestureRecognizer.bitrise_swizzle_methods()
        
        NSError.bitrise_swizzle_methods()
        
        JSContext.bitrise_swizzle_methods()
    }
    
    // MARK: - Session
    
    /// Internal use only
    internal static func reset() {
        let session = CACurrentMediaTime()
        
        Trace.currentSession = session
    }
    
    // MARK: - Lifecycle
    
    /// Internal use only
    internal func didComeBackToForeground() {
        Trace.reset()
        queue.restart()
        session.restart()
        
        crash.scheduleNewReports()
    }
}

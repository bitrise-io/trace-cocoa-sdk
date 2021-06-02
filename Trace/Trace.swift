//
//  Trace.swift
//  Trace
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/**
 Trace SDK

 Trace: https://trace.bitrise.io
 What's Trace? https://www.bitrise.io/add-ons/trace-mobile-monitoring
 Getting started guide: https://trace.bitrise.io/o/getting-started
 Trace configuration settings: https://trace.bitrise.io/settings
 
 Did you know Trace is open sourced? https://github.com/bitrise-io/trace-cocoa-sdk
 Report issues: https://github.com/bitrise-io/trace-cocoa-sdk/issues/new
 
*/
@objcMembers
@objc(BRTrace)
final public class Trace: NSObject {
    
    // MARK: - Static Property
    
    /// Shared instance
    public static let shared: Trace = Trace()
    
    /// Configuration
    public static var configuration: Configuration = .default
    
    /// Current session time interval
    public private(set) static var currentSession: CFTimeInterval = 0.0
    
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
    internal let tracer: Tracer
    private let lifecycle: Lifecycle
    private let session: Session
    private let fps: FPS
    private let scheduler: Scheduler
    
    /// Crash controller
    public let crash: CrashController
    
    // MARK: - Static Method
    
    /// Internal use only
    internal static func reset() {
        let session = Time.current
        Trace.currentSession = session
    }
    
    // MARK: - Init
    
    private override init() {
        let initializationTime = Time.timestamp
        
        Trace.preSetup()
        
        session = Session()
        network = Network()
        database = Database()
        lifecycle = Lifecycle()
        scheduler = Scheduler(with: network)
        queue = Queue(with: scheduler, database, session)
        crash = CrashController(with: scheduler, resource: session.resource)
        tracer = Tracer(with: queue, session, crash)
        fps = FPS()
        
        super.init()
        
        setup(with: initializationTime)
    }
    
    // MARK: - Setup
    
    private static func preSetup() {
        if Trace.currentSession == 0 {
            Logger.warning(.internalError, "SDK launched without a valid startup session")
            
            Trace.reset()
        }
        
        if !Trace.configuration.enabled {
            Logger.error(.internalError, "SDK started up manually while Trace.configuration.enabled is set to false")
        }
    }
    
    private func setup(with initializationTime: Time.Timestamp) {
        #if DEBUG || Debug || debug
        Logger.print(.crash, "Disabled since app is running in Debug mode")
        #else
        setupCrashReporting()
        #endif
        
        Logger.print(.launch, "Bitrise Trace version: \(Constants.SDK.version.rawValue) - Beta")
        
        setupConfiguration()
        
        if Trace.configuration.log == .warning {
            Logger.default(.application, "Verbose logs has been enabled while in Beta. Configure in Swift: `Trace.configuration.log` ObjC: `BRTrace.configuration.log`")
        }
        
        setupSwizzle()
        setupStartupTrace(with: initializationTime)
    }
    
    private func setupConfiguration() {
        let configurationInteractor = TraceConfigurationInteractor(network: network)
        configurationInteractor.setup()
    }
    
    private func setupCrashReporting() {
        CrashReporting.observe()
        crash.postSetup(with: session.resource)
    }
    
    private func setupSwizzle() {
        TraceSwizzleInteractor.setup()
    }
    
    private func setupStartupTrace(with initializationTime: Time.Timestamp) {
        let trace = StartupFormatter(initializationTime, status: .cold).trace
        
        tracer.add(trace)
    }
    
    // MARK: - Lifecycle
    
    /// Internal use only
    internal func didComeBackToForeground() {
        Logger.debug(.application, "did come back to foreground")
        
        Trace.reset()
        queue.restart()
        session.restart()
        crash.scheduleNewReports()
    }
}

//
//  Trace.swift
//  Trace
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import QuartzCore.CABase

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
        let session = CACurrentMediaTime()
        Trace.currentSession = session
    }
    
    // MARK: - Init
    
    private override init() {
        session = Session()
        network = Network()
        database = Database()
        scheduler = Scheduler(with: network)
        queue = Queue(with: scheduler, database, session) // make sure queue startup first
        lifecycle = Lifecycle()
        crash = CrashController(with: scheduler)
        tracer = Tracer(with: queue, session, crash)
        fps = FPS()
        
        super.init()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        Logger.print(.launch, "Bitrise Trace version: \(Constants.SDK.version.rawValue)")
        
        setupConfiguration()
        setupCrashReporting()
        setupSwizzle()
    }
    
    private func setupConfiguration() {
        let configurationInteractor = TraceConfigurationInteractor(network: network)
        configurationInteractor.setup()
    }
    
    private func setupCrashReporting() {
        CrashReporting.observe()
        crash.setup()
    }
    
    private func setupSwizzle() {
        TraceSwizzleInteractor.setup()
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

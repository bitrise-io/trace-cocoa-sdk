//
//  Startup.swift
//  Trace
//
//  Created by Shams Ahmed on 28/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

/// Startup class provide information about how long a app taking to startup
internal final class Startup {
    
    // MARK: - Property
    
    private var didBecomeActiveNotification: NSObjectProtocol?
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        queue.name = Constants.SDK.name.rawValue + ".Startup"
        queue.maxConcurrentOperationCount = 2
        
        return queue
    }()
    
    // MARK: - Init
    
    internal init() {
        setup()
    }
    
    deinit {
        didBecomeActiveNotification = nil
    }
    
    // MARK: - Setup
    
    private func setup() {
        startObserver()
    }
    
    // MARK: - Observer
    
    private func startObserver() {
        didBecomeActiveNotification = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: queue,
            using: didBecomeActive
        )
    }
    
    // MARK: - Notification
    
    private func didBecomeActive(_ notification: Notification) {
        process()
    }
    
    // MARK: - Process
    
    private func process() {
        processMetric()
        processTrace()
    }
    
    private func processMetric() {
        let currentSession = Trace.currentSession
        
        func sdkLaunchedWithoutAValidStartupSession() {
            Logger.warning(.internalError, "SDK launched without a valid startup session, bypassing startup metric")
        }
        
        guard currentSession != 0 else {
            sdkLaunchedWithoutAValidStartupSession()
            
            return
        }
        
        // Compare start and end time.
        // Start time is updated when the SDK start
        let time = Time.current
        let result = time - currentSession
        let formatter = StartupFormatter(result, status: .cold)
        
        Trace.shared.queue.add(formatter.metrics)
    }
    
    private func processTrace() {
        let tracer = Trace.shared.tracer
        
        // Trace will always be in active traces as startup is short lived
        guard let model = tracer.traces.first(where: { $0.type == .startup }) else {
            Logger.warning(.traceModel, "Failed to locate Startup trace model")
            
            return
        }
        
        tracer.finish(model)
    }
}

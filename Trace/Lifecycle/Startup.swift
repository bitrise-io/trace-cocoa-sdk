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
    private var didBecomeActiveNotificationScene: NSObjectProtocol?
    
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
        didBecomeActiveNotificationScene = nil
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
        
        // Fallback if UIApplication.didBecomeActiveNotification does not get triggered for unknown reasons
        if #available(iOS 13.0, *) {
            didBecomeActiveNotificationScene = NotificationCenter.default.addObserver(
                forName: UIScene.didActivateNotification,
                object: nil,
                queue: queue,
                using: didBecomeActiveScene
            )
        }
    }
    
    func stopObserver() {
        let notificationCenter = NotificationCenter.default
        
        if let notification = didBecomeActiveNotification {
            notificationCenter.removeObserver(notification)
        }
        
        if let notification = didBecomeActiveNotificationScene {
            notificationCenter.removeObserver(notification)
        }
        
        didBecomeActiveNotification = nil
        didBecomeActiveNotificationScene = nil
    }
    
    // MARK: - Notification
    
    private func didBecomeActive(_ notification: Notification) {
        process()
    }
    
    private func didBecomeActiveScene(_ notification: Notification) {
        let time = Time.current
        let timestamp = Time.timestamp
   
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 10) { [weak self] in
            let tracer = Trace.shared.tracer
            
            if tracer.traces.contains(where: { $0.type == .startup }) {
                Logger.warning(.launch, "didBecomeActiveNotification was not triggered, fallback method called in UIScene")
                
                self?.process(with: time, customTimestamp: timestamp)
            }
        }
    }
    
    // MARK: - Process
    
    @discardableResult
    private func process(with time: CFTimeInterval = Time.current, customTimestamp: Time.Timestamp? = nil) -> Bool {
        let metricResult = processMetric(with: time)
        let traceResult = processTrace(with: customTimestamp)
        
        return metricResult && traceResult
    }
    
    @discardableResult
    private func processMetric(with time: CFTimeInterval) -> Bool {
        let currentSession = Trace.currentSession
        
        func sdkLaunchedWithoutAValidStartupSession() {
            Logger.warning(.internalError, "SDK launched without a valid startup session, bypassing startup metric")
        }
        
        guard currentSession != 0 else {
            sdkLaunchedWithoutAValidStartupSession()
            
            return false
        }
        
        // Compare start and end time.
        // Start time is updated when the SDK start
        let result = time - currentSession
        let formatter = StartupFormatter(result, status: .cold)
        
        Trace.shared.queue.add(formatter.metrics)
        
        return true
    }
    
    @discardableResult
    private func processTrace(with customTimestamp: Time.Timestamp? = nil) -> Bool {
        let tracer = Trace.shared.tracer
        
        // Trace will always be in active traces as startup is short lived
        guard let model = tracer.traces.first(where: { $0.type == .startup }) else {
            Logger.warning(.traceModel, "Failed to locate Startup trace model")
            
            return false
        }
        
        return tracer.finish(model, withCustomTimestamp: customTimestamp)
    }
}

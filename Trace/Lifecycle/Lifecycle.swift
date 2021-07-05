//
//  Lifecycle.swift
//  Trace
//
//  Created by Shams Ahmed on 06/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

/// Lifecycle class monitors app lifecycle and update the states on the SDK
final internal class Lifecycle {
    
    // MARK: - Property
    
    private var willEnterForegroundNotification: NSObjectProtocol?
    private var didEnterBackgroundNotification: NSObjectProtocol?
    private var willTerminateNotification: NSObjectProtocol?
    private var didReceiveMemoryWarningNotification: NSObjectProtocol?
    
    private var didEnterBackgroundOnce = false
    
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        queue.name = Constants.SDK.name.rawValue + ".Lifecycle"
        queue.maxConcurrentOperationCount = 2
        
        return queue
    }()
    private let startup: Startup
    
    // MARK: - Init
    
    init() {
        startup = Startup()
        
        setup()
    }
    
    deinit {
        willEnterForegroundNotification = nil
        didEnterBackgroundNotification = nil
        willTerminateNotification = nil
        didReceiveMemoryWarningNotification = nil
    }
    
    // MARK: - Setup
    
    private func setup() {
        startObserver()
    }
    
    // MARK: - Observer
    
    func startObserver() {
        let notificationCenter = NotificationCenter.default
        
        willEnterForegroundNotification = notificationCenter.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: queue,
            using: { [weak self] _ in
                // iOS Demo project doesn't call this notification
                // While on a new project it gets called.
                // Safe guard is place to avoid false metric for warm startup
                if self?.didEnterBackgroundOnce == true {
                    self?.processWillEnterForeground()
                    
                    Trace.shared.didComeBackToForeground()
                }
            }
        )
        didEnterBackgroundNotification = notificationCenter.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: queue,
            using: { [weak self] _ in
                self?.processLifecycle(.background)
                
                self?.didEnterBackgroundOnce = true
            }
        )
        willTerminateNotification = notificationCenter.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: queue,
            using: { [weak self] _ in
                self?.processLifecycle(.terminated)
                
                Trace.shared.database.saveAll()
            }
        )
        didReceiveMemoryWarningNotification = notificationCenter.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: queue,
            using: { _ in Logger.error(.application, "Received memory warning") }
        )
    }
    
    // pecker:ignore
    func stopObserver() {
        let notificationCenter = NotificationCenter.default
        
        if let notification = willEnterForegroundNotification {
            notificationCenter.removeObserver(notification)
        }
        
        if let notification = didEnterBackgroundNotification {
            notificationCenter.removeObserver(notification)
        }
        
        if let notification = willTerminateNotification {
            notificationCenter.removeObserver(notification)
        }
        
        if let notification = didReceiveMemoryWarningNotification {
            notificationCenter.removeObserver(notification)
        }
        
        willEnterForegroundNotification = nil
        didEnterBackgroundNotification = nil
        willTerminateNotification = nil
        didReceiveMemoryWarningNotification = nil
    }
    
    // MARK: - Process
    
    private func processLifecycle(_ reason: SessionFormatter.Reason) {
        // trace
        Trace.shared.tracer.finishAll()
    }
    
    private func processWillEnterForeground() {
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
        
        let time = Time.current
        let session = time - currentSession
        let formatter = StartupFormatter(session, status: .warm)
        
        Trace.shared.queue.add(formatter.metrics)
    }
    
    private func processTrace() {
        let initializationTime = Time.timestamp
        let trace = StartupFormatter(initializationTime, status: .warm).trace
        
        Trace.shared.tracer.add(trace)
    }
}

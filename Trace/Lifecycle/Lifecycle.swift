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
        
    private var didFinishLaunchingNotification: NSObjectProtocol?
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
        didFinishLaunchingNotification = nil
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
    
    private func startObserver() {
        let notificationCenter = NotificationCenter.default
        
        didFinishLaunchingNotification = notificationCenter.addObserver(
            forName: UIApplication.didFinishLaunchingNotification,
            object: nil,
            queue: queue,
            using: { _ in }
        )
        willEnterForegroundNotification = notificationCenter.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: queue,
            using: { [weak self] _ in
                // iOS Demo project doesn't call this notification
                // While on a new project it gets called.
                // Safe guard is place to avoid false metric for warm startup
                if self?.didEnterBackgroundOnce == true {
                    self?.process()
                    
                    Trace.shared.didComeBackToForeground()
                }
            }
        )
        didEnterBackgroundNotification = notificationCenter.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: queue,
            using: { [weak self] _ in
                self?.process(.background)
                
                self?.didEnterBackgroundOnce = true
            }
        )
        willTerminateNotification = notificationCenter.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: queue,
            using: { [weak self] _ in
                self?.process(.terminated)
                
                Trace.shared.database.saveAll()
            }
        )
        didReceiveMemoryWarningNotification = notificationCenter.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: queue,
            using: { _ in Logger.print(.application, "Received memory warning") }
        )
    }
    
    // pecker:ignore
    private func stopObserver() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(didFinishLaunchingNotification as Any)
        notificationCenter.removeObserver(willEnterForegroundNotification as Any)
        notificationCenter.removeObserver(didEnterBackgroundNotification as Any)
        notificationCenter.removeObserver(willTerminateNotification as Any)
        notificationCenter.removeObserver(didReceiveMemoryWarningNotification as Any)
    }
    
    // MARK: - Process
    
    private func process(_ reason: SessionFormatter.Reason) {
        // trace
        Trace.shared.tracer.finishAll()
        
        // metrics
        // SKIPPED till post MVP
//        let time = Time.current
//        let session = time - Trace.currentSession
//        let formatter = SessionFormatter(reason, time: session)
//
//        Trace.shared.queue.add(formatter.metrics)
    }
    
    private func process() {
        let currentSession = Trace.currentSession
        
        guard currentSession != 0 else {
            Logger.print(.internalError, "SDK launched without a valid startup session, bypassing startup metric")
            
            return
        }
        
        let time = Time.current
        let session = time - currentSession
        let formatter = StartupFormatter(session, status: .warm)
        
        Trace.shared.queue.add(formatter.metrics)
    }
}

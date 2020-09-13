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
    
    private func stopObserver() {
        NotificationCenter.default.removeObserver(didBecomeActiveNotification as Any)
    }
    
    // MARK: - Notification
    
    private func didBecomeActive(_ notification: Notification) {
        process()
        
        stopObserver()
    }
    
    // MARK: - Process
    
    private func process() {
        let currentSession = Trace.currentSession
        
        guard currentSession != 0 else {
            Logger.print(.internalError, "SDK launched without a valid startup session, bypassing startup metric")
            
            return
        }
        
        // Compare start and end time.
        // Start time is updated when the SDK start
        let time = Time.current
        let result = time - currentSession
        let formatter = StartupFormatter(result, status: .cold)
        
        Trace.shared.queue.add(formatter.metrics)
    }
}

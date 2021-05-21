//
//  FPS.swift
//  Trace
//
//  Created by Shams Ahmed on 27/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

internal protocol FPSProtocol {
    var current: FPS.Result { get }
}

final class FPS: FPSProtocol {
    
    // MARK: - Struct
    
    struct Result {
        let timestamp: Time.Timestamp
        let fps: Double
        let viewController: String
    }
    
    // MARK: - Property
    
    /// Class provided by Apple to help get FPS details
    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(
            target: self,
            selector: #selector(FPS.step(_:))
        )
        displayLink.add(to: .main, forMode: .common)
        
        return displayLink
    }()
    
    var lastNotification: CFAbsoluteTime = 0.0
    private var numberOfFrames: Int = 0
    
    var delay: TimeInterval = 1.5
    
    var current: Result = Result(timestamp: Time.timestamp, fps: 0, viewController: "") {
        didSet {
            let formatter = FPSFormatter(current)
            let metrics = formatter.metrics
            
            if !metrics.metrics.isEmpty {
                Trace.shared.queue.add(metrics)
            }
        }
    }
    
    // MARK: - Init
    
    internal init() {
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        _ = displayLink
    }
    
    // MARK: - Callback
    
    @objc
    func step(_ displaylink: CADisplayLink) {
        process(displayLink)
    }
    
    // MARK: - Process
    
    /// Process FPS
    private func process(_ displaylink: CADisplayLink) {
        guard lastNotification != 0.0 else {
            lastNotification = CFAbsoluteTimeGetCurrent()
            
            return
        }
        
        // Increment frames to compare afterwards
        numberOfFrames += 1
        
        let currentTime = CFAbsoluteTimeGetCurrent()
        let elapsedTime = currentTime - lastNotification
        let timestamp = Time.timestamp
        
        if elapsedTime >= delay {
            // compare value to find result
            let fps = round(Double(numberOfFrames) / elapsedTime)
            
            // get view name
            var viewController: String? {
                guard let viewController = UIApplication.shared.currentViewController() else { return nil }
                
                return "\(type(of: viewController))"
            }
            
            guard let viewControllerName = viewController else { return }
            
            current = Result(timestamp: timestamp, fps: fps, viewController: viewControllerName)
            
            lastNotification = 0.0
            numberOfFrames = 0
        }
    }
}

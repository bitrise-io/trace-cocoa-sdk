//
//  Repeater.swift
//  Trace
//
//  Created by Shams Ahmed on 26/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Helper to get Timer like feature that minimal load and high performance
internal final class Repeater {

    // MARK: - Enum
    
    internal enum State {
        case suspend
        case resume
    }
    
    // MARK: - Property
    
    internal var timeInterval: TimeInterval {
        didSet {
            adjustTimer()
        }
    }
   
    internal var handler: (() -> Void)?
    
    private let dispatchQueue = DispatchQueue(
        label: Constants.SDK.name.rawValue + ".Repeater",
        qos: .background
    )
    
    private lazy var timer: DispatchSourceTimer = {
        return createTimer(with: self.timeInterval)
    }()
    
    internal var state: State = .suspend {
        didSet {
            switch state {
            case .resume where oldValue != .resume: timer.resume()
            case .suspend where oldValue != .suspend: timer.suspend()
            default: break
            }
        }
    }
    
    // MARK: - Init
    
    init(_ timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    deinit {
        timer.setEventHandler { }
        timer.cancel()
        
        // https://forums.developer.apple.com/thread/15902
        // To avoid crashes state must be set to .resume
        state = .resume
        
        handler = nil
    }
    
    // MARK: - Timer
    
    private func createTimer(with timeInterval: TimeInterval) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(queue: dispatchQueue)
        timer.schedule(
            deadline: .now() + timeInterval,
            repeating: timeInterval,
            leeway: .seconds(2)
        )
        timer.setEventHandler(handler: { [weak self] in
            self?.handler?()
        })
        
        return timer
    }
    
    private func adjustTimer() {
        state = .suspend
        
        timer.schedule(
            deadline: .now() + timeInterval,
            repeating: timeInterval,
            leeway: .seconds(2)
        )
        
        state = .resume
    }
}

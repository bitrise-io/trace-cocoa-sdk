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
    
    private let timeInterval: TimeInterval
   
    internal var handler: (() -> Void)?
    
    private let dispatchQueue = DispatchQueue(
        label: Constants.SDK.name.rawValue + ".Repeater",
        qos: .background
    )
    
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(queue: self.dispatchQueue)
        timer.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        timer.setEventHandler(handler: { [weak self] in
            self?.handler?()
        })
        
        return timer
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
}

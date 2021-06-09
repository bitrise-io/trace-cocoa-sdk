//
//  Time.swift
//  Trace
//
//  Created by Shams Ahmed on 25/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import QuartzCore.CABase

protocol Timestampable {
    
    // MARK: - Property
    
    var seconds: Int { get }
    var nanos: Int { get }
}

/// Time helper
internal enum Time {
    
    // MARK: - Timestamp
    
    struct Timestamp: Timestampable, Encodable {
        
        // MARK: - Property
        
        let seconds, nanos: Int
        let timeInterval: TimeInterval
        
        // MARK: - Init
        
        init(seconds: Int, nanos: Int, timeInterval: TimeInterval) {
            self.seconds = seconds
            self.nanos = nanos
            self.timeInterval = timeInterval
            
            setup()
        }
        
        // MARK: - Setup
        
        private func setup() {
            #if DEBUG || Debug || debug
                // TODO: only for private beta testing. remove before GA
                if !TimestampValidator(toDate: Date()).isValid(seconds: seconds, nanos: nanos) {
                    Logger.debug(.internalError, "Timestamp \(seconds).\(nanos) is greater than the  current time")
                }
            #endif
        }
    }
    
    // MARK: - Property
    
    /// Timestamp using Date
    internal static var timestamp: Timestamp {
        let date = Date()
        
        return from(date)
    }
    
    /// Absolute time
    internal static var current: Double {
        // Use CA library to maximise performance
        return CACurrentMediaTime()
    }
    
    // MARK: - Timestamp
    
    internal static func from(_ date: Date) -> Timestamp {
        let time = date.timeIntervalSince1970
        let split = time.splitAtDecimal
        
        return Timestamp(
            seconds: split.integer,
            nanos: split.fractional,
            timeInterval: time
        )
    }
    
    // MARK: - Timer
    
    /// Calculate time based on a block
    internal static func time(_ block: () -> Void) -> Double {
        var info = mach_timebase_info()
        
        guard mach_timebase_info(&info) == KERN_SUCCESS else { return -1 }
        
        let start = mach_absolute_time()
        
        block()
        
        let end = mach_absolute_time()
        let elapsed = end - start
        let nanos = elapsed * UInt64(info.numer) / UInt64(info.denom)
        
        return TimeInterval(nanos) / TimeInterval(NSEC_PER_SEC)
    }
}

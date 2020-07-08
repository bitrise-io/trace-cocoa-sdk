//
//  Time.swift
//  Trace
//
//  Created by Shams Ahmed on 25/06/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import QuartzCore.CABase

/// Time helper
internal enum Time {
    
    // MARK: - Timestamp
    
    struct Timestamp: Encodable {
        let seconds, nanos: Int
        let timeInterval: TimeInterval
    }
    
    // MARK: - Property
    
    /// Timestamp using Date
    internal static var timestamp: Timestamp {
        let date = Date()
        
        return from(date)
    }
    
    internal static func from(_ date: Date) -> Timestamp {
        let time = date.timeIntervalSince1970
        let split = time.splitAtDecimal
        
        return Timestamp(seconds: split.integer, nanos: split.fractional, timeInterval: time)
    }
    
    /// Absolute time
    internal static var current: Double {
        // Use CA library to maximise performance
        return CACurrentMediaTime()
    }
    
    // MARK: - Timer
    
    // Calculate time based on a block
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

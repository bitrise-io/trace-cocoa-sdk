//
//  TimestampValidator.swift
//  Trace
//
//  Created by Shams Ahmed on 17/07/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Only for testing
internal struct TimestampValidator {

    // MARK: - Property
    
    let toDate: Date
    
    // MARK: - Validator
    
    func isValid(timestamp: Time.Timestamp) -> Bool {
        return isValid(seconds: timestamp.seconds, nanos: timestamp.nanos)
    }
    
    func isValid(seconds: Int, nanos: Int) -> Bool {
        let joinedValue = Double("\(seconds).\(nanos)") ?? 0.0
        let date = Date(timeIntervalSince1970: joinedValue)
        let components = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: date,
            to: toDate
        )

        if let year = components.year,
            let month = components.month,
            let day = components.day,
            year == 0, month == 0, day == 0 {
            return true
        }
        
        Logger.print(.internalError, "Invalid timestamp \(components)")
        
        return false
    }
}
//
//  Date+Helper.swift
//  Trace
//
//  Created by Shams Ahmed on 03/08/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK: - Timestamp {
    
    static func date<T: Timestampable>(from timestamp: T) -> Date {
        var joinedValue = 0.0
        
        if let value = Double("\(timestamp.seconds).\(timestamp.nanos)") {
            joinedValue = value
        }
        
        let date = Date(timeIntervalSince1970: joinedValue)
        
        return date
    }
}

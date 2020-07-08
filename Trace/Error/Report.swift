//
//  Report.swift
//  Trace
//
//  Created by Shams Ahmed on 07/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

extension CrashReporting {
    
    // MARK: - Report
    
    internal struct Report {
        
        // MARK: - Enum
        
        enum `Type`: String {
            case signal
            case exception
        }
        
        // MARK: - Property
        
        internal let timestamp: Time.Timestamp = Time.timestamp
        internal let type: `Type`
        internal let name: String
        internal let reason: String
        internal let callStack: String
    }
}

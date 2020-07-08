//
//  FilterStringToData.swift
//  Trace
//
//  Created by Shams Ahmed on 14/02/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Internal use only
@objcMembers
@objc(BRFilterStringToData)
internal final class FilterStringToData: NSObject, KSCrashReportFilter {
  
    // MARK: - KSCrashReportFilter
    
    func filterReports(_ reports: [Any]!, onCompletion: KSCrashReportFilterCompletion!) {
        let filteredReports = reports
            .compactMap { $0 as? String }
            .compactMap { $0.data(using: .utf8) }
        
        kscrash_callCompletion(onCompletion, filteredReports, true, nil)
    }
}

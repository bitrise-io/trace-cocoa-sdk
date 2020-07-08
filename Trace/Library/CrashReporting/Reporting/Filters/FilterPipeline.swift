//
//  FilterPipeline.swift
//  Trace
//
//  Created by Shams Ahmed on 17/02/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Internal use only
@objcMembers
@objc(BRFilterPipeline)
internal final class FilterPipeline: NSObject, KSCrashReportFilter {
    
    // MARK: - Enum
    
    enum Error: Swift.Error {
        case filteredReportsNil
    }
    
    // MARK: - Property
    
    internal var filters = [KSCrashReportFilter]()

    // MARK: - Init

    /// Batch X number of filters and process the final result
    static func with(filters: [KSCrashReportFilter]) -> FilterPipeline {
        let pipline = FilterPipeline()
        pipline.filters = filters
        
        return pipline
    }
  
    // MARK: - KSCrashReportFilter
    
    func filterReports(_ reports: [Any]!, onCompletion: KSCrashReportFilterCompletion!) {
        guard !filters.isEmpty else { return kscrash_callCompletion(onCompletion, reports, true, nil) }
        
        let filters = self.filters
        let count = filters.count
        
        var iFilter = 0
        var filterCompletion: KSCrashReportFilterCompletion?
        var weakFilterCompletion: KSCrashReportFilterCompletion?
        
        let disposeOfCompletion: () -> Void = {
            DispatchQueue.main.async {
                filterCompletion = nil
            }
        }
        
        filterCompletion = { filteredReports, completed, filterError in
            if !completed || filteredReports == nil {
                if !completed {
                    kscrash_callCompletion(onCompletion, filteredReports, completed, filterError)
                } else if filteredReports == nil {
                    kscrash_callCompletion(onCompletion, filteredReports, false, Error.filteredReportsNil as NSError)
                }
                
                disposeOfCompletion()
                
                return
            }
            
            iFilter += 1
            
            if iFilter < count {
                let filter = filters[iFilter]
                filter.filterReports(filteredReports, onCompletion: weakFilterCompletion)
                
                return
            }
            
            kscrash_callCompletion(onCompletion, filteredReports, completed, filterError)

            disposeOfCompletion()
        }
        
        weakFilterCompletion = filterCompletion
        
        let filter = filters[iFilter]
        filter.filterReports(reports, onCompletion: filterCompletion)
    }
}

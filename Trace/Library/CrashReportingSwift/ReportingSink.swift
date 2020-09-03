//
//  ReportingSink.swift
//  Trace
//
//  Created by Shams Ahmed on 06/02/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Internal use only
@objc(BRReportingSink)
@objcMembers
internal final class ReportingSink: NSObject, KSCrashReportFilter {
    
    // MARK: - Property

    var filter: KSCrashReportFilter! {
        FilterPipeline.with(filters: [
            KSCrashReportFilterAppleFmt.filter(with: KSAppleReportStyleSymbolicated),
            FilterStringToData(),
            self
        ])
    }
    
    private let fileName: String
        
    // MARK: - Init
    
    internal init(with fileName: String) {
        self.fileName = fileName
        
        super.init()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
       
    }
    
    // MARK: - KSCrashReportFilter
    
    // Convert json crash report into Apple style format and save to disk
    internal func filterReports(_ reports: [Any]!, onCompletion: KSCrashReportFilterCompletion!) {
        var path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0] as NSString
        path = path.appendingPathComponent(Constants.SDK.company.rawValue) as NSString
        path = path.appendingPathComponent("Crashes") as NSString
        path = path.appendingPathComponent("Formatted") as NSString
        
        reports
            .compactMap { $0 as? Data }
            .enumerated()
            .forEach { offset, report in
                let name = String(format: fileName, offset + 1)
                let url = URL(fileURLWithPath: path.appendingPathComponent(name))
                
                save(report, at: url)
            }
        
        kscrash_callCompletion(onCompletion, reports, true, nil)
    }
    
    // MARK: - Save
    
    @discardableResult
    private func save(_ report: Data, at location: URL) -> Bool {
        do {
            try report.write(to: location)
            
            return true
        } catch {
            Logger.print(.internalError, "Failed to write crash report to document directory")
            
            return false
        }
    }
}

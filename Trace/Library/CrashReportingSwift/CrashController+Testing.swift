//
//  CrashController+Testing.swift
//  Trace
//
//  Created by Shams Ahmed on 30/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Exclude class
public extension CrashController {
    
    // MARK: - Property - Testing
    
    /// Testing only unformatted in JSON
    var allReports: [Any] {
        let reports: [Any] = installation.allReport()
        
        Logger.error(.internalError, "Warning: Do not use in production app, method only intended for testing")
        Logger.error(.crash, "Report count: \(reports.count)")
        
        return reports
    }
    
    // MARK: - Testing
    
    /// Testing only unformatted in Apple format
    func allReports(_ completion: @escaping ([Any]) -> Void) {
        installation.allReports { [weak self] reports, _, error in
            Logger.error(.internalError, "Warning: Do not use in production app, method only intended for testing")
            Logger.error(.crash, "Report count: \(reports?.count ?? 0)")

            if let error = error {
                Logger.error(.internalError, error.localizedDescription)
            }

            completion(reports ?? [])

            self?.cleanUp()
        }
    }
}

//
//  CrashController.swift
//  Trace
//
//  Created by Shams Ahmed on 10/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
//import TraceInternal

/// CrashController
@objcMembers
@objc(BRCrashController)
public final class CrashController: NSObject {
    
    // MARK: - Property
    
    private let scheduler: Scheduler
    
    /// Internal use only
//    internal lazy var installation: TraceInternal.KSCrashInstallation = KSCrashInstallation()
    
    internal var userInfo: [AnyHashable: Any] {
        get {
            return [:] // installation.userInfo
        }
        set {
//            installation.userInfo = newValue
        }
    }
    
    // MARK: - Init
    
    internal init(with scheduler: Scheduler) {
        self.scheduler = scheduler
        
        super.init()
    }
    
    // MARK: - Setup
    
    /// Call setup before acessing crash installation
    /// Called afterward SDK has started
    internal func setup() {
        // installation.install()
        
        scheduleNewReports()
    }
    
    // MARK: - Schedule
    
    internal func scheduleNewReports() {
//        installation.allReports { [weak self] processedReports, _, _ in
//            var count = 0
//
//            if let processedCount = processedReports?.count {
//                count = processedCount
//
//                if processedCount != 0 {
//                    Logger.print(.crash, "Report count: \(count)")
//                }
//            }
//
//            processedReports?
//                .compactMap { $0 as? Data }
//                .forEach { self?.send(report: $0) }
//        }
    }
    
    // MARK: - Send
    
    @discardableResult
    internal func send(report: Data) -> Bool {
        let interpreter = AppleCrashFormatInterpreter(report)
        
        do {
            // Create model out of the raw Apple format.
            // Since it all string based it isn't easy to handle like JSON and plist
            let model = try interpreter.toModel().get()
            let crash = Crash(id: model.id,
                              timestamp: model.timestamp,
                              title: "Crash_report",
                              report: report
            )
            
            // Send report to backend
            scheduler.schedule(crash) { [weak self] in
                switch $0 {
                case .success: self?.cleanUp()
                case .failure: Logger.print(.crash, "Failed to submit report")
                }
            }
            
            return true
        } catch {
            Logger.print(.crash, "Failed to create crash report")
            
            return false
        }
    }
    
    // MARK: - Clean up
    
    @discardableResult
    internal func cleanUp() -> Bool {
        // installation.deleteAllReports()
        
        return true
    }
}

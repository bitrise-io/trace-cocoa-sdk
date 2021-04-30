//
//  CrashController.swift
//  Trace
//
//  Created by Shams Ahmed on 10/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

#if canImport(TraceInternal)
import TraceInternal
#endif

/// CrashController
@objcMembers
@objc(BRCrashController)
public final class CrashController: NSObject {
    
    // MARK: - Enum
    
    enum Keys: String {
        case traceId = "Trace Id"
        case resource = "Resource"
    }
    
    // MARK: - Property
    
    private let scheduler: Scheduler
    
    /// Internal use only
    #if canImport(TraceInternal)
    internal lazy var installation: TraceInternal.KSCrashInstallation = TraceInternal.KSCrashInstallation()
    #else
    internal lazy var installation: KSCrashInstallation = KSCrashInstallation()
    #endif
    
    internal var userInfo: [AnyHashable: Any] {
        get {
            return installation.userInfo
        }
        set {
            installation.userInfo = newValue
        }
    }
    
    // MARK: - Init
    
    internal init(with scheduler: Scheduler, resource: Resource) {
        self.scheduler = scheduler
        
        super.init()
        
        setup(with: resource)
    }
    
    // MARK: - Setup
    
    private func setup(with resource: Resource) {
        
    }
    
    /// Called after SDK has finished starting up
    internal func postSetup(with resource: Resource) {
        let asyncDelay = 1.5
        
        if !installation.install() {
            Logger.error(.crash, "Failed to install handler")
            
            // Fallback if crash handler isn't ready to be set
            // When is is called the App hasn't loaded all library in it's memory,
            // which could explain why it fails i.e Objective-C runtime, c++ library etc..
            DispatchQueue.global().asyncAfter(deadline: .now() + asyncDelay, execute: { [weak self] in
                self?.installation.install()
                self?.updateUserInfo(with: resource)
            })
        }
        
        updateUserInfo(with: resource)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + (asyncDelay * 2), execute: { [weak self] in
            self?.scheduleNewReports()
        })
    }
    
    // MARK: - UserInfo
    
    private func updateUserInfo(with resource: Resource) {
        if let dictionary = try? resource.dictionary() {
            userInfo[Keys.resource.rawValue] = dictionary
        }
    }
    
    // MARK: - Schedule
    
    internal func scheduleNewReports() {
        installation.allReports { [weak self] processedReports, _, _ in
            var count = 0

            if let processedCount = processedReports?.count {
                count = processedCount

                if processedCount != 0 {
                    Logger.default(.crash, "Report count: \(count)")
                }
            }

            processedReports?
                .compactMap { $0 as? Data }
                .forEach { self?.send(report: $0) }
        }
    }
    
    // MARK: - Send
    
    @discardableResult
    internal func send(report: Data) -> Bool {
        let interpreter = AppleCrashFormatInterpreter(report)
        
        do {
            // Create model out of the raw Apple format.
            // Since it all string based it isn't easy to handle like JSON and plist
            let model = try interpreter.toModel().get()
            let sessionId = model.sessionId
            let crashedWithoutSession: Bool = sessionId.isEmpty || sessionId == " "
            let title = model.title.isEmpty || model.title == " "
                ? "Unknown exception type"
                : model.title
            let crash = Crash(
                id: model.id,
                timestamp: model.timestamp,
                title: title,
                appVersion: model.appVersion,
                buildVersion: model.buildVersion,
                osVersion: model.osVersion,
                deviceType: model.deviceType,
                sessionId: model.sessionId,
                network: model.network,
                carrier: model.carrier,
                deviceId: model.deviceId,
                eventIdentifier: model.eventIdentifier,
                crashedWithoutSession: crashedWithoutSession,
                report: report
            )
            
            // Send report to backend
            scheduler.schedule(crash) { [weak self] in
                switch $0 {
                case .success: self?.cleanUp()
                case .failure: break
                }
            }
            
            return true
        } catch {
            Logger.error(.crash, "Failed to create crash report")
            
            return false
        }
    }
    
    // MARK: - Clean up
    
    @discardableResult
    internal func cleanUp() -> Bool {
        installation.deleteAllReports()
        
        return true
    }
}

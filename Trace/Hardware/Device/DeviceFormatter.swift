//
//  DeviceFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 02/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

#if !targetEnvironment(macCatalyst)
import CoreTelephony.CTTelephonyNetworkInfo
#endif

internal struct DeviceFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    enum Keys: String {
        enum Locale: String {
            case languageCode = "device.locale.language.code"
            case identifier = "device.locale"
        }
        
        enum Process: String {
            case thermalState = "process.thermal.state"
            case name = "process.name"
        }
        
        enum Screen: String {
            case screenBounds = "screen.bounds"
        }
        
        enum Application: String {
            case id = "br.app.id"
            case name = "app.name"
            case version = "app.version"
            case build = "app.build"
            case state = "app.state"
            case powerState = "app.power.state"
        }
        
        enum Disk: String {
            case totalDiskSpace = "disk.total.disk.space"
            case freeDiskSpace = "disk.free.disk.space"
            case usedDiskSpace = "disk.used.disk.space"
        }
        
        enum Carrier: String {
            case name = "device.carrier"
        }
        
        enum SDK: String {
            case version
        }
        
        case uuid = "device.id"
        case uuidType = "device.id.type"
        case batteryState = "app.power.state"
        case batteryLevel = "device.battery.level"

        case model = "device.type"
        case platform = "app.platform"
        case systemVersion = "os.version"
        case name = "device.name"
        case jailbroken = "device.jailbroken"
    }

    // MARK: - Property
    
    let timestamp = Time.timestamp
    
    internal var details: OrderedDictionary<String, String> {
        var details = OrderedDictionary<String, String>()
        
        // UIDevice
        let device: UIDevice = .current
                
        if let system = device.identifierForVendor {
            details[Keys.uuid.rawValue] = system.uuidString
        } else {
            let temporary = UUID().uuidString
            
            details[Keys.uuid.rawValue] = temporary
        }
        
        details[Keys.model.rawValue] = device.model
        details[Keys.systemVersion.rawValue] = device.systemVersion
        details[Keys.name.rawValue] = device.name
        details[Keys.platform.rawValue] = "iOS"
        
        let locale = Locale.current
        
        details[Keys.Locale.languageCode.rawValue] = locale.languageCode ?? "Unknown"
        details[Keys.Locale.identifier.rawValue] = locale.identifier
        
        // ProcessInfo
        let process = ProcessInfo.processInfo
        
        details[Keys.Process.name.rawValue] = process.processName
        
        // Bundle
        let bundle = Bundle.main
        let version = bundle.infoDictionary?[kCFBundleVersionKey as String] as? String
        let build = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        let name = bundle.infoDictionary?[kCFBundleNameKey as String] as? String
        let identifier = bundle.infoDictionary?[kCFBundleIdentifierKey as String] as? String
        
        details[Keys.Application.version.rawValue] = build ?? "Unknown"
        details[Keys.Application.build.rawValue] = version ?? "Unknown"
        details[Keys.Application.name.rawValue] = name ?? "Unknown"
        details[Keys.Application.id.rawValue] = identifier ?? "Unknown"
        
        // FileManager
        let fileManager = FileManager.default
        
        details[Keys.Disk.totalDiskSpace.rawValue] = fileManager.totalDiskSpace
        details[Keys.Disk.freeDiskSpace.rawValue] = fileManager.freeDiskSpace
        details[Keys.Disk.usedDiskSpace.rawValue] = fileManager.usedDiskSpace
        
        #if !targetEnvironment(macCatalyst)
        let networkInfo = CTTelephonyNetworkInfo()
        
        if #available(iOS 12.0, *) {
            if let carriers = networkInfo.serviceSubscriberCellularProviders {
                let names = carriers
                    .map { $0.value.carrierName }
                    .compactMap { $0 }
                    .joined()
                
                if !names.isEmpty {
                    details[Keys.Carrier.name.rawValue] = names
                }
            }
        } else if let carrier = networkInfo.subscriberCellularProvider {
            if let name = carrier.carrierName, !name.isEmpty {
                details[Keys.Carrier.name.rawValue] = name
            }
        }
        #endif
        
        let isJailbroken = UIDevice.current.isJailbroken
        
        details[Keys.jailbroken.rawValue] = isJailbroken ? "true" : "false"
        details[Keys.SDK.version.rawValue] = Constants.SDK.version.rawValue
        
        return details
    }
}

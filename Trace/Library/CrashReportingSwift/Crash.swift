//
//  Crash.swift
//  Trace
//
//  Created by Shams Ahmed on 10/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Crash model for network
internal struct Crash: Encodable {
    
    // MARK: - Enum
    
    private enum CodingKeys: String, CodingKey {
        case report
        case id = "trace_id"
        case title
        case timestamp
        case appVersion = "app_version"
        case buildVersion = "build_id"
        case OSVersion = "os_version"
        case deviceType = "device_type"
        case sessionId = "session_id"
        case network = "device_network"
        case carrier = "device_carrier"
        case deviceId = "device_id"
        case crashedWithoutSession = "crashed_without_session"
        case eventIdentifier = "sdk_event_identifier"
    }
    
    // MARK: - Property
    
    internal let id: String
    internal let timestamp: String
    internal let title: String
    internal let appVersion: String
    internal let buildVersion: String
    internal let osVersion: String
    internal let deviceType: String
    internal let sessionId: String
    internal let network: String
    internal let carrier: String
    internal let deviceId: String
    internal let eventIdentifier: String
    internal let crashedWithoutSession: Bool
    
    /// Sent as multipart form data
    internal let report: Data
    
    // MARK: - Encodable
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(title, forKey: .title)
        try container.encode(appVersion, forKey: .appVersion)
        try container.encode(buildVersion, forKey: .buildVersion)
        try container.encode(osVersion, forKey: .OSVersion)
        try container.encode(deviceType, forKey: .deviceType)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(network, forKey: .network)
        try container.encode(carrier, forKey: .carrier)
        try container.encode(deviceId, forKey: .deviceId)
        try container.encode(eventIdentifier, forKey: .eventIdentifier)
        try container.encode(crashedWithoutSession, forKey: .crashedWithoutSession)
        
        // Report not required
    }
}

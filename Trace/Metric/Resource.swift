//
//  Metrics+Resource.swift
//  Trace
//
//  Created by Shams Ahmed on 19/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Resource model
struct Resource: Codable {
    
    // MARK: - Enum
    
    private enum CodingKeys: CodingKey {
        enum Labels: String, CodingKey {
            case appVersion = "app.version"
            case uuid = "device.id"
            case osVersion = "os.version"
            case deviceType = "device.type"
            case platform = "app.platform"
            case carrier = "device.carrier"
            case network = "device.network"
            case sessionId = "app.session.id"
            case jailbroken = "device.jailbroken"
            case sdkVersion = "sdk.version"
        }
        
        case type
        case labels
    }
    
    // MARK: - Property
    
    let type: String = "mobile"
    let platform: String = "iOS"
    let appVersion: String
    let uuid: String
    let osVersion: String
    let deviceType: String
    let carrier: String
    let jailbroken: String
    let sdkVersion: String
    
    var network: String
    var session: String
    
    // MARK: - Init
    
    init(from details: OrderedDictionary<String, String>) {
        appVersion = details[DeviceFormatter.Keys.Application.version.rawValue] ?? ""
        uuid = details[DeviceFormatter.Keys.uuid.rawValue] ?? ""
        osVersion = details[DeviceFormatter.Keys.systemVersion.rawValue] ?? ""
        deviceType = details[DeviceFormatter.Keys.model.rawValue] ?? ""
        carrier = details[DeviceFormatter.Keys.Carrier.name.rawValue] ?? ""
        jailbroken = details[DeviceFormatter.Keys.jailbroken.rawValue] ?? ""
        sdkVersion = details[DeviceFormatter.Keys.SDK.version.rawValue] ?? ""
        network = ""
        session = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(
            keyedBy: CodingKeys.Labels.self,
            forKey: .labels
        )
        
        appVersion = try nestedContainer.decode(String.self, forKey: .appVersion)
        uuid = try nestedContainer.decode(String.self, forKey: .uuid)
        osVersion = try nestedContainer.decode(String.self, forKey: .osVersion)
        deviceType = try nestedContainer.decode(String.self, forKey: .deviceType)
        carrier = try nestedContainer.decode(String.self, forKey: .carrier)
        network = try nestedContainer.decode(String.self, forKey: .network)
        session = try nestedContainer.decode(String.self, forKey: .sessionId)
        jailbroken = try nestedContainer.decode(String.self, forKey: .jailbroken)
        sdkVersion = try nestedContainer.decode(String.self, forKey: .sdkVersion)
    }
    
    // MARK: - Encode
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.Labels.self, forKey: .labels)
        
        try container.encode(type, forKey: .type)
        try nestedContainer.encode(appVersion, forKey: .appVersion)
        try nestedContainer.encode(uuid, forKey: .uuid)
        try nestedContainer.encode(osVersion, forKey: .osVersion)
        try nestedContainer.encode(deviceType, forKey: .deviceType)
        try nestedContainer.encode(carrier, forKey: .carrier)
        try nestedContainer.encode(network, forKey: .network)
        try nestedContainer.encode(session, forKey: .sessionId)
        try nestedContainer.encode(platform, forKey: .platform)
        try nestedContainer.encode(jailbroken, forKey: .jailbroken)
        try nestedContainer.encode(sdkVersion, forKey: .sdkVersion)
    }
}

extension Resource: Hashable {
    
    // MARK: - Equatable
    
    static func == (lhs: Resource, rhs: Resource) -> Bool {
        return
            lhs.appVersion == rhs.appVersion &&
            lhs.osVersion == rhs.osVersion &&
            lhs.uuid == rhs.uuid &&
            lhs.session == rhs.session
    }
}

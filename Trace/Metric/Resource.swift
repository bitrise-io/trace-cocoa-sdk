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
    
    enum ConfigurationMode: String, Codable {
        case debug
        case release
        case unknown
    }
    
    enum Environment: String, Codable {
        case normal
        case unitTest
        case UITest
        case unknown
    }
    
    enum DistributionMethod: String, Codable {
        case adhoc
        case testflight
        case appStore
        case enterprise
        case unknown
    }
    
    enum CodingKeys: String, CodingKey {
        enum Labels: String, CodingKey {
            case appVersion = "app.version"
            case buildVersion = "app.build"
            case uuid = "device.id"
            case osVersion = "os.version"
            case osBuild = "os.build"
            case deviceType = "device.type"
            case platform = "app.platform"
            case carrier = "device.carrier"
            case network = "device.network"
            case sessionId = "app.session.id"
            case jailbroken = "device.jailbroken"
            case sdkVersion = "sdk.version"
            case configurationMode = "app.configuration.mode"
            case environment = "app.environment"
            case distributionMethod = "app.distribution.method"
        }
        
        case type
        case labels
    }
    
    // MARK: - Property
    
    let type: String = "mobile"
    let platform: String
    let appVersion: String
    let buildVersion: String
    let uuid: String
    let osVersion: String
    let osBuild: String
    let deviceType: String
    let carrier: String
    let jailbroken: String
    let sdkVersion: String
    let configurationMode: String
    let environment: String
    let distributionMethod: String
    
    var network: String
    var session: String
    
    // MARK: - Init
    
    init(from details: OrderedDictionary<String, String>, sessionId: String = "") {
        appVersion = details[DeviceFormatter.Keys.Application.version.rawValue] ?? ""
        buildVersion = details[DeviceFormatter.Keys.Application.build.rawValue] ?? ""
        uuid = details[DeviceFormatter.Keys.uuid.rawValue] ?? ""
        osVersion = details[DeviceFormatter.Keys.systemVersion.rawValue] ?? ""
        osBuild = details[DeviceFormatter.Keys.systemBuild.rawValue] ?? ""
        deviceType = details[DeviceFormatter.Keys.model.rawValue] ?? ""
        carrier = details[DeviceFormatter.Keys.Carrier.name.rawValue] ?? ""
        jailbroken = details[DeviceFormatter.Keys.jailbroken.rawValue] ?? ""
        sdkVersion = details[DeviceFormatter.Keys.SDK.version.rawValue] ?? ""
        platform = details[DeviceFormatter.Keys.platform.rawValue] ?? ""
        configurationMode = details[DeviceFormatter.Keys.Application.configurationMode.rawValue] ?? ConfigurationMode.unknown.rawValue
        environment = details[DeviceFormatter.Keys.Application.environment.rawValue] ?? Environment.unknown.rawValue
        distributionMethod = details[DeviceFormatter.Keys.Application.distributionMethod.rawValue] ?? DistributionMethod.unknown.rawValue
        
        network = ""
        session = sessionId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(
            keyedBy: CodingKeys.Labels.self,
            forKey: .labels
        )
        
        appVersion = try nestedContainer.decode(String.self, forKey: .appVersion)
        buildVersion = try nestedContainer.decode(String.self, forKey: .buildVersion)
        uuid = try nestedContainer.decode(String.self, forKey: .uuid)
        osVersion = try nestedContainer.decode(String.self, forKey: .osVersion)
        osBuild = try nestedContainer.decodeIfPresent(String.self, forKey: .osBuild) ?? ""
        deviceType = try nestedContainer.decode(String.self, forKey: .deviceType)
        carrier = try nestedContainer.decode(String.self, forKey: .carrier)
        network = try nestedContainer.decode(String.self, forKey: .network)
        session = try nestedContainer.decode(String.self, forKey: .sessionId)
        jailbroken = try nestedContainer.decode(String.self, forKey: .jailbroken)
        sdkVersion = try nestedContainer.decode(String.self, forKey: .sdkVersion)
        platform = try nestedContainer.decode(String.self, forKey: .platform)
        configurationMode = try nestedContainer.decodeIfPresent(String.self, forKey: .configurationMode) ?? ConfigurationMode.unknown.rawValue
        environment = try nestedContainer.decodeIfPresent(String.self, forKey: .environment) ?? Environment.unknown.rawValue
        distributionMethod = try nestedContainer.decodeIfPresent(String.self, forKey: .distributionMethod) ?? DistributionMethod.unknown.rawValue
    }
    
    // MARK: - Encode
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.Labels.self, forKey: .labels)
        
        try container.encode(type, forKey: .type)
        try nestedContainer.encode(appVersion, forKey: .appVersion)
        try nestedContainer.encode(buildVersion, forKey: .buildVersion)
        try nestedContainer.encode(uuid, forKey: .uuid)
        try nestedContainer.encode(osVersion, forKey: .osVersion)
        try nestedContainer.encode(osBuild, forKey: .osBuild)
        try nestedContainer.encode(deviceType, forKey: .deviceType)
        try nestedContainer.encode(carrier, forKey: .carrier)
        try nestedContainer.encode(network, forKey: .network)
        try nestedContainer.encode(session, forKey: .sessionId)
        try nestedContainer.encode(platform, forKey: .platform)
        try nestedContainer.encode(jailbroken, forKey: .jailbroken)
        try nestedContainer.encode(sdkVersion, forKey: .sdkVersion)
        try nestedContainer.encode(configurationMode, forKey: .configurationMode)
        try nestedContainer.encode(environment, forKey: .environment)
        try nestedContainer.encode(distributionMethod, forKey: .distributionMethod)
    }
}

extension Resource: Hashable {
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(appVersion)
        hasher.combine(buildVersion)
        hasher.combine(osVersion)
        hasher.combine(uuid)
        hasher.combine(session)
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Resource, rhs: Resource) -> Bool {
        return
            lhs.appVersion == rhs.appVersion &&
            lhs.buildVersion == rhs.buildVersion &&
            lhs.osVersion == rhs.osVersion &&
            lhs.uuid == rhs.uuid &&
            lhs.session == rhs.session
    }
}

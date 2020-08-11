//
//  Configuration.swift
//  Trace
//
//  Created by Shams Ahmed on 18/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal struct BitriseConfiguration: Decodable {

    // MARK: - Enum
    
    internal enum CodingKeys: String, CodingKey {
        case token = "APM_COLLECTOR_TOKEN"
        case environment = "APM_COLLECTOR_ENVIRONMENT"
        case installationSource = "APM_INSTALLATION_SOURCE"
    }
    
    // MARK: - Property
    
    /// Token
    let token: String
    
    /// Environment, Optional..
    let environment: URL?
    
    /// Source of installation, Optional i.e Bitrise
    let installationSource: String?
    
    // MARK: - Init
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        token = try container.decode(String.self, forKey: .token)
        
        if let value = try container.decodeIfPresent(String.self, forKey: .environment),
            let url = URL(string: value) {
            environment = url
        } else {
            environment = nil
        }
        
        if let value = try container.decodeIfPresent(String.self, forKey: .installationSource) {
            installationSource = value
        } else {
            installationSource = nil
        }
    }
}

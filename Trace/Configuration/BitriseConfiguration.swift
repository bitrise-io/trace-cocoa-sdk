//
//  Configuration.swift
//  Trace
//
//  Created by Shams Ahmed on 18/07/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation

internal struct BitriseConfiguration: Decodable {

    // MARK: - Enum
    
    internal enum CodingKeys: String, CodingKey {
        case token = "APM_COLLECTOR_TOKEN"
        case environment = "APM_COLLECTOR_ENVIRONMENT"
    }
    
    // MARK: - Property
    
    /// Token
    let token: String
    
    /// Environment, Optional..
    let environment: URL?
    
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
    }
}

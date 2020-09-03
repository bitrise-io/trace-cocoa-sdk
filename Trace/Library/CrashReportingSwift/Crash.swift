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
        case id = "trace_id"
        case title
        case timestamp
    }
    
    // MARK: - Property
    
    internal let id: String
    internal let timestamp: String
    internal let title: String
    
    /// Sent as multipart form data
    internal let report: Data
    
    // MARK: - Encodable
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(title, forKey: .title)
    }
}

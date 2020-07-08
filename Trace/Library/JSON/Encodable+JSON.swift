//
//  Encodable+JSON.swift
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// JSON decoder
internal extension Encodable {
    
    // MARK: - Encoder
    
    private var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
    
        return encoder
    }

    // MARK: - JSON

    /// Convert object to JSON
    ///
    /// - Returns: Data
    /// - Throws: JSON Error
    func json() throws -> Data {
        let encoder = jsonEncoder
        
        return try encoder.encode(self)
    }

    /// Convert object to JSON String
    ///
    /// - Returns: String
    /// - Throws: JSON Error
    func jsonString() -> String? {
        let encoder = jsonEncoder
        
        guard let data = try? encoder.encode(self) else { return nil }

        let json = String(data: data, encoding: String.Encoding.utf8)

        return json
    }
}

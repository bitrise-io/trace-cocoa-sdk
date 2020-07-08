//
//  JSONDecoder+Helper.swift
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// JSONDecoder
internal extension JSONDecoder {
    
    // MARK: - Enum
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    // MARK: - Decode optional
    
    /// Unwrap data and return model
    ///
    /// - Parameters:
    ///   - type: type
    ///   - data: data
    /// - Returns: model
    /// - Throws: error
    func decode<T>(_ type: T.Type, from data: Data?) throws -> T where T: Decodable {
        guard let unwrapped = data else {
            throw Error.invalidData
        }
        
        return try decode(type, from: unwrapped)
    }
}

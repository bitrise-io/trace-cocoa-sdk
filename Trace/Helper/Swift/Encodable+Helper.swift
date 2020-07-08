//
//  Encodable+Helper.swift
//  Trace
//
//  Created by Shams Ahmed on 14/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Helper for encoding models
extension Encodable {
    
    // MARK: - Empty
    
    var isObjectEmpty: Bool {
        switch self {
        case let value as String where value.isEmpty:
            return true
        case let value as EmptyCollection<Any> where value.isEmpty:
            return true
        case let value as [String: Any] where value.isEmpty:
            return true
        case let value as [Any] where value.isEmpty:
            return true
        default:
            return false
        }
    }
    
    // MARK: - Dictionary
    
    func dictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        guard let dictionary = json as? [String: Any] else {
            throw NSError(domain: "Dictionary json encoding error", code: 1, userInfo: nil)
        }
        
        return dictionary
    }
}

//
//  Decodable+Helper.swift
//  Trace
//
//  Created by Shams Ahmed on 04/05/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension Decodable {

    // MARK: - From dictionary
    
    init(dictionary: [String: Any]) throws {
        let decoder = JSONDecoder()
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        
        self = try decoder.decode(Self.self, from: data)
    }
}

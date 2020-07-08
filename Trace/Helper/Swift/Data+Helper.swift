//
//  Data+Helper.swift
//  Trace
//
//  Created by Shams Ahmed on 13/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Helper to append string to data
extension Data {
    
    // MARK: - String
    
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

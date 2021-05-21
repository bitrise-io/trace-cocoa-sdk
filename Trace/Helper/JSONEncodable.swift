//
//  JSONEncodable.swift
//  Trace
//
//  Created by Shams Ahmed on 11/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

protocol JSONEncodable {
    
    // MARK: - Details
    
    var details: OrderedDictionary<String, String> { get }
    
    // MARK: - JSON
    
    var data: Data? { get }
    var jsonString: String { get }
}

/// Json model helper
extension JSONEncodable {
    
    // MARK: - JSON
    
    internal var data: Data? {
        let data = try? JSONEncoder().encode(details)
        
        return data
    }
    
    internal var jsonString: String {
        var dataToConvert = Data()
        
        if let data = data {
            dataToConvert = data
        }
        
        var json = ""
        
        if let converted = String(data: dataToConvert, encoding: .utf8) {
            json = converted
        }
        
        return json
    }
}

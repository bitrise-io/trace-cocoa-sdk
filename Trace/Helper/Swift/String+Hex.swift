//
//  String+Hex.swift
//  Trace
//
//  Created by Shams Ahmed on 16/10/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Helper for making use of Hex in a string object
extension String {
    
    // MARK: - To Hex
    
    var toHex: String {
        Data(utf8)
            .map { String(format: "%02x", $0) }
            .joined()
    }
    
    // MARK: - From Hex
    
    var fromHex: String? {
        let chars = Array(utf8)
        let map: [UInt8] = [
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, // 01234567
            0x08, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 89:;<=>?
            0x00, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x00, // @ABCDEFG
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  // HIJKLMNO
        ]

        var bytes = [UInt8]()
        bytes.reserveCapacity(count / 2)
        
        for i in stride(from: 0, to: count, by: 2) {
            let index1 = Int(chars[i] & 0x1F ^ 0x10)
            let index2 = Int(chars[i + 1] & 0x1F ^ 0x10)
            
            bytes.append(map[index1] << 4 | map[index2])
        }
        
        let data = Data(bytes)
        let string = String(data: data, encoding: .utf8)
        
        if string == nil || string?.isEmpty == true || string == " " {
            Logger.error(.internalError, "Failed to convert HEX to UTF 8 string")
        }
        
        return string
    }
}

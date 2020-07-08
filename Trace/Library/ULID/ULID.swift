//
//  ULID.swift
//  Trace
//
//  Created by Shams Ahmed on 24/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Universally Unique Lexicographically Sortable Identifier
/// https://github.com/ulid/spec
/// Long story short similar to UUID but allow backend to search, sort and index must easier
internal struct ULID {
    
    // MARK: - Property - Static
    
    /// ULID string
    static var string: String {
        let ulid = ULID()
       
        return ulid.time + ulid.random
    }
    
    // MARK: - Property
    
    let time: String
    let random: String
    
    /// ULID string
    var string: String { time + random }
    
    // MARK: - Static
    
    // Create random section with length using Base 32
    private static func encodeRandom(with length: Int) -> String {
        var str = ""
        
        for _ in (0..<length).reversed() {
            // Get the floor of a random value
            let rand = floor(Base32.length * Double.random)
        
            str = Base32.array[Int(rand)] + str
        }
        
        return str
    }
    
    // Create time section with length using Base 32
    private static func encodeTime(_ time: Double, length: Int) -> String {
        var chaingTime = time
        var xstr = ""
        
        for _ in (0..<length).reversed() {
            // Get the mod of a random value
            let mod = Int(chaingTime.truncatingRemainder(dividingBy: Base32.length))
            
            xstr = Base32.array[mod] + xstr
            chaingTime -= Double(mod) / Base32.length
        }
        
        return xstr
    }
    
    // MARK: - Init
    
    init() {
        let now = Date().timeIntervalSince1970
        
        // Default length
        time = ULID.encodeTime(now, length: 10)
        random = ULID.encodeRandom(with: 16)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
}

fileprivate extension ULID {
    
    // MARK: - Crockford
    
    // Crockford's Base32 - https://en.wikipedia.org/wiki/Base32
    struct Base32 {
        
        // MARK: - Property
        
        static let array = "0123456789ABCDEFGHJKMNPQRSTVWXYZ".map { String($0) }
        static let length: Double = Double(array.count)
    }
}

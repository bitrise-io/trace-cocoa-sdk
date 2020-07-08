//
//  UUID.swift
//  Trace
//
//  Created by Shams Ahmed on 11/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Helper to get a random UUID uisng letters and numbers
extension UUID {
    
    // MARK: - Random
    
    static func random(_ length: Int) -> String {
        let lowcaseLetters = "abcdefghijklmnopqrstuvwxyz"
        let uppercaseLetters = lowcaseLetters.uppercased()
        let numbers = "0123456789"
        let letters = lowcaseLetters + uppercaseLetters + numbers
        
        let result = (0..<length).compactMap { _ in letters.randomElement() }
        
        return String(result)
    }
}

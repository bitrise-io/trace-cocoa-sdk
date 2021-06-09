//
//  Double+Helper.swift
//  Trace
//
//  Created by Shams Ahmed on 14/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Helper to work with Double values
extension Double {
    
    // MARK: - Typealias
    
    typealias Split = (integer: Int, fractional: Int)
    
    // MARK: - Random
    
    static var random: Double { Double(arc4random()) / 0xFFFFFFFF }
    
    // MARK: - Class - Split
    
    static func split(atDecimal decimal: String) -> Split {
        let split = decimal.split(separator: ".")
        let integer = Int(split.first ?? "")
        let fractional = Int(split.last ?? "")
        
        return Split(
            integer: integer ?? 0,
            fractional: fractional ?? 0
        )
    }
    
    // MARK: - Split
    
    /// 123.45 split to 123 and 450000000?
    var splitAtDecimal: Split {
        let string = String(format: "%0.9f", self)
        let split = Self.split(atDecimal: string)
        
        return split
    }
    
    // MARK: - Round
    
    func rounded(to scale: Int) -> Double {
        var decimalValue = Decimal(self)
        var result = Decimal()
        
        NSDecimalRound(&result, &decimalValue, scale, .plain)
        
        let resultDouble = (result as NSDecimalNumber).doubleValue
        
        return resultDouble
    }
}

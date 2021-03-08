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
    
    /// 123.45 split to 123 and 45
    var splitAtDecimal: Split {
        let split = Self.split(atDecimal: String(self))
        
        return split
    }
    
    // MARK: - Round
    
    func roundFraction(to scale: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.roundingMode = .halfEven
        formatter.minimumFractionDigits = scale
        formatter.maximumFractionDigits = scale

        let result = formatter.string(for: self)
        
        return result
    }
    
    func rounded(to scale: Int) -> Double {
        var decimalValue = Decimal(self)
        var result = Decimal()
        
        NSDecimalRound(&result, &decimalValue, scale, .plain)
        
        return (result as NSDecimalNumber).doubleValue
    }
}

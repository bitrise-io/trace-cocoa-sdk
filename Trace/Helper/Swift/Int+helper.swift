//
//  Int+helper.swift
//  Trace
//
//  Created by Shams Ahmed on 08/03/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation

/// Helper to work with Int values
extension Int {
    
    // MARK: - Round
  
    func rounded(to scale: Int) -> Int {
        var decimalValue = Decimal(self)
        var result = Decimal()
        
        NSDecimalRound(&result, &decimalValue, scale, .plain)
        
        let resultInt = (result as NSDecimalNumber).intValue
        
        return resultInt
    }
}

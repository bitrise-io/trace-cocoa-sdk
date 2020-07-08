//
//  ViewFilter.swift
//  Trace
//
//  Created by Shams Ahmed on 08/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

internal extension UIView {
    
    // MARK: - Enum
    
    /// Not all views are useful from a tracing point of view.
    private enum Banned: String, CaseIterable {
        case ns = "NS"
        case uiKit = "UI"
        case webkit = "WK"
        case safari = "SF"
        case coreVideo = "CV"
        case avKit = "AV"
        case coreAnimation = "CA"
        case coreGraphics = "CG"
        case spriteKit = "SK"
        case quartz = "QL"
    }
    
    // MARK: - Internal
    
    /// Banned and internal classes are excluded
    var isInternalClass: Bool {
        let `class` = String(describing: type(of: self))
        
        return `class`.hasPrefix("_")
    }
    
    /// Banned and internal classes are excluded
    var isBannedClass: Bool {
        let `class` = String(describing: type(of: self))
        let cases = Banned.allCases.map { $0.rawValue }
        
        for prefix in cases where `class`.hasPrefix(prefix) {
            return true
        }
        
        return false
    }
}

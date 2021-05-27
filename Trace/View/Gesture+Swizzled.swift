//
//  Gesture+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 18/11/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

/// Internal use only
/// Disabled
extension UIGestureRecognizer: Swizzled {
    
    // MARK: - Swizzled
    
    // pecker:ignore
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        let initTarget = Selectors(
            original: #selector(UIGestureRecognizer.init(target:action:)),
            alternative: #selector(UIGestureRecognizer.init(bitrise_target:action:))
        )
        let initCoder = Selectors(
            original: #selector(UIGestureRecognizer.init(coder:)),
            alternative: #selector(UIGestureRecognizer.init(bitrise_coder:))
        )
        let touchesBegan = Selectors(
            original: #selector(UIGestureRecognizer.touchesBegan(_:with:)),
            alternative: #selector(UIGestureRecognizer.touchesBegan(bitrise_touch:with:))
        )
        let touchesEnded = Selectors(
            original: #selector(UIGestureRecognizer.touchesEnded(_:with:)),
            alternative: #selector(UIGestureRecognizer.touchesEnded(bitrise_touch:with:))
        )
        let pressesBegan = Selectors(
            original: #selector(UIGestureRecognizer.pressesBegan(_:with:)),
            alternative: #selector(UIGestureRecognizer.pressesBegan(bitrise_presses:with:))
        )
        let pressesEnded = Selectors(
            original: #selector(UIGestureRecognizer.pressesBegan(_:with:)),
            alternative: #selector(UIGestureRecognizer.pressesBegan(bitrise_presses:with:))
        )
        
        _ = self.swizzleInstanceMethod(initTarget)
        _ = self.swizzleInstanceMethod(initCoder)
        _ = self.swizzleInstanceMethod(touchesBegan)
        _ = self.swizzleInstanceMethod(touchesEnded)
        _ = self.swizzleInstanceMethod(pressesBegan)
        _ = self.swizzleInstanceMethod(pressesEnded)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return .success
    }

    // MARK: - Init
    
    @objc
    convenience init(bitrise_target target: Any?, action: Selector?) {
        self.init(bitrise_target: target, action: action)
        
        process()
    }
    
    @objc
    convenience init?(bitrise_coder aDecoder: NSCoder) {
        self.init(bitrise_coder: aDecoder)
        
        process()
    }
    
    // MARK: - Tracking
    
    @objc
    func touchesBegan(bitrise_touch touches: Set<UITouch>, with event: UIEvent) {
        self.touchesBegan(bitrise_touch: touches, with: event)
        
        Logger.debug(.prototype, "Touch begin for type \(type(of: self))")
    }

    @objc
    func touchesEnded(bitrise_touch touches: Set<UITouch>, with event: UIEvent) {
        self.touchesEnded(bitrise_touch: touches, with: event)
        
        Logger.debug(.prototype, "Touch ended for type \(type(of: self))")
    }
    
    @objc
    func pressesBegan(bitrise_presses presses: Set<UIPress>, with event: UIPressesEvent) {
        self.pressesBegan(bitrise_presses: presses, with: event)
        
        Logger.debug(.prototype, "Presses begin for type \(type(of: self))")
    }

    @objc
    func pressesEnded(bitrise_presses presses: Set<UIPress>, with event: UIPressesEvent) {
        self.pressesEnded(bitrise_presses: presses, with: event)
        
        Logger.debug(.prototype, "Presses ended for type \(type(of: self))")
    }

    // MARK: - Process

    private func process() {
        Logger.debug(.prototype, "Gesture created for \(type(of: self))")
        
        addTarget(self, action: #selector(bitrise_all(_:)))
    }
    
    // MARK: - Target
    
    @objc
    private func bitrise_all(_ sender: UIGestureRecognizer) {
        Logger.debug(.prototype, "\(sender)")
    }
}

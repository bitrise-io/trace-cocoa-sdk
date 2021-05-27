//
//  Control+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 18/11/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

// MARK: - Control

/// Internal use only
/// Disabled
/// pecker:ignore
internal final class UIControl_Swizzled: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        let coder = Selectors(
            original: #selector(UIControl.init(coder:)),
            alternative: #selector(UIControl.init(bitrise_control_coder:))
        )
        let frame = Selectors(
            original: #selector(UIControl.init(frame:)),
            alternative: #selector(UIControl.init(bitrise_control_frame:))
        )
        let begin = Selectors(
            original: #selector(UIControl.beginTracking(_:with:)),
            alternative: #selector(UIControl.beginTracking(bitrise_touch:with:))
        )
        let end = Selectors(
            original: #selector(UIControl.endTracking(_:with:)),
            alternative: #selector(UIControl.endTracking(bitrise_touch:with:))
        )
        
        _ = UIControl.swizzleInstanceMethod(coder)
        _ = UIControl.swizzleInstanceMethod(frame)
        _ = UIControl.swizzleInstanceMethod(begin)
        _ = UIControl.swizzleInstanceMethod(end)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return .success
    }
}

internal extension UIControl {
    
    // MARK: - Init

    @objc
    convenience init?(bitrise_control_coder aDecoder: NSCoder) {
        self.init(bitrise_control_coder: aDecoder)
        
        process()
    }
    
    @objc
    convenience init(bitrise_control_frame: CGRect) {
        self.init(bitrise_control_frame: bitrise_control_frame)
        
        process()
    }
    
    // MARK: - Tracking
    
    @objc
    func beginTracking(bitrise_touch touch: UITouch, with event: UIEvent?) -> Bool {
        let result = self.beginTracking(bitrise_touch: touch, with: event)
        
        Logger.debug(.prototype, "Begin \(event?.description ?? "unknown")")
        
        return result
    }

    @objc
    func endTracking(bitrise_touch touch: UITouch?, with event: UIEvent?) {
        self.endTracking(bitrise_touch: touch, with: event)
        
        Logger.debug(.prototype, "End \(event?.description ?? "unknown")")
    }
    
    // MARK: - Process

    private func process() {
        guard actions(forTarget: self, forControlEvent: .touchUpInside) == nil else {
            Logger.debug(.prototype, "Control action for \(type(of: self)) already assigned for .touchUpInside event")
            
            return
        }
        
        addTarget(
            self,
            action: #selector(bitrise_touchUpInside(sender:forEvent:)),
            for: .touchUpInside
        )
        addTarget(
            self,
            action: #selector(bitrise_primaryActionTriggered(sender:forEvent:)),
            for: .primaryActionTriggered
        )
        
        Logger.debug(.prototype, "Control action for \(type(of: self))")
    }
    
    // MARK: - Target
    
    @objc
    private func bitrise_touchUpInside(sender: UIControl, forEvent event: UIEvent) {
        // Output the view, frame and where inside the frame a touch occured
        // Know issues UISlider and UISegmented control need different control type
        Logger.debug(.prototype, "Control touchUpInside \(event.allTouches?.first?.description ?? "unknown")")
    }
    
    @objc
    private func bitrise_primaryActionTriggered(sender: UIControl, forEvent event: UIEvent) {
        // Output the view, frame and where inside the frame a touch occured
        Logger.debug(.prototype, "Control primaryActionTriggered \(event.allTouches?.first?.description ?? "unknown")")
    }
}

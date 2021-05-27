//
//  View+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 19/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

// MARK: - View

/// Disabled
/// Internal use only
extension UIView: Swizzled {
    
    // MARK: - Enum
    
    private struct AssociatedKey {
        static var session = "br_view_session"
    }
    
    // MARK: - Metric
    
    final class Metric: CustomStringConvertible {
        
        // MARK: - Property
        
        var observed: Bool = true
        
        let name: String
        var initWithCoder: Time.Timestamp?
        var initWithFrame: Time.Timestamp?
        var layoutSubviews: Time.Timestamp?
        var draw: Time.Timestamp?
        var didMoveToSuperview: Time.Timestamp?
        var didMoveToWindow: Time.Timestamp?
        var removeFromSuperview: Time.Timestamp?
        
        // MARK: - Init
        
        init(name: String) {
            self.name = name
        }
        
        // MARK: - Duration
        
        var duration: Double {
            // compare the earliest known start time.
            var start: Double = 0.0
            var end = 0.0
            
            if let didMove = didMoveToSuperview?.timeInterval {
                end = didMove
            } else {
                Logger.debug(.internalError, "Failed to find view (\(name)) end time")
            }
            
            // since the are many ways to create a view it's best to check all and in the correct lifecycle order
            if let value = initWithCoder {
                start = value.timeInterval
            } else if let value = initWithFrame {
                start = value.timeInterval
            } else {
                Logger.debug(.internalError, "Failed to find view (\(name)) start time")
            }
            
            let result = end - start
            
            return result
        }
        
        // MARK: - Description
        
        var description: String {
            return "\(type(of: self)) - name: \(name), initWithCoder: \(String(describing: initWithCoder)), initWithFrame: \(String(describing: initWithFrame)), layoutSubviews: \(String(describing: layoutSubviews)), draw: \(String(describing: draw)), didMoveToSuperview: \(String(describing: didMoveToSuperview)), didMoveToWindow: \(String(describing: didMoveToWindow)), removeFromSuperview: \(String(describing: removeFromSuperview))"
        }
    }
    
    // MARK: - Property
    
    var metric: Metric {
        get {
            if let metric = objc_getAssociatedObject(self, &AssociatedKey.session) as? Metric {
                return metric
            } else {
                let metric = Metric(name: "\(type(of: self))")
                
                self.metric = metric
                
                return metric
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.session, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        let coder = Selectors(
            original: #selector(UIView.init(coder:)),
            alternative: #selector(UIView.init(bitrise_view_coder:))
        )
        let frame = Selectors(
            original: #selector(UIView.init(frame:)),
            alternative: #selector(UIView.init(bitrise_view_frame:))
        )
        let layoutSubviews = Selectors(
            original: #selector(UIView.layoutSubviews),
            alternative: #selector(UIView.bitrise_layoutSubviews)
        )
        let didMoveToSuperview = Selectors(
            original: #selector(UIView.didMoveToSuperview),
            alternative: #selector(UIView.bitrise_didMoveToSuperview)
        )
        let didMoveToWindow = Selectors(
            original: #selector(UIView.didMoveToWindow),
            alternative: #selector(UIView.bitrise_didMoveToWindow)
        )
        let draw = Selectors(
            original: #selector(UIView.draw(_:)),
            alternative: #selector(UIView.bitrise_draw(_:))
        )
        let removeFromSuperview = Selectors(
            original: #selector(UIView.removeFromSuperview),
            alternative: #selector(UIView.bitrise_removeFromSuperview)
        )
        
        _ = self.swizzleInstanceMethod(coder)
        _ = self.swizzleInstanceMethod(frame)
        _ = self.swizzleInstanceMethod(layoutSubviews)
        _ = self.swizzleInstanceMethod(draw)
        _ = self.swizzleInstanceMethod(didMoveToSuperview)
        _ = self.swizzleInstanceMethod(didMoveToWindow)
        _ = self.swizzleInstanceMethod(removeFromSuperview)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return .success
    }
    
    // MARK: - Init

    @objc
    convenience init?(bitrise_view_coder aDecoder: NSCoder) {
        self.init(bitrise_view_coder: aDecoder)
        
        metric.initWithCoder = Time.timestamp
    }
    
    @objc
    convenience init(bitrise_view_frame: CGRect) {
        self.init(bitrise_view_frame: bitrise_view_frame)
        
        metric.initWithFrame = Time.timestamp
    }
    
    // MARK: - Layout
    
    @objc
    func bitrise_layoutSubviews() {
        self.bitrise_layoutSubviews()
        
        metric.layoutSubviews = Time.timestamp
    }
    
    @objc
    func bitrise_draw(_ rect: CGRect) {
        self.bitrise_draw(rect)
        
        metric.draw = Time.timestamp
    }
    
    @objc
    func bitrise_removeFromSuperview() {
        self.bitrise_removeFromSuperview()
        
        if metric.removeFromSuperview == nil {
            metric.removeFromSuperview = Time.timestamp
            
            process()
        }
    }

    // MARK: - Presenation

    @objc
    func bitrise_didMoveToSuperview() {
        self.bitrise_didMoveToSuperview()
        
        if metric.didMoveToSuperview == nil {
            metric.didMoveToSuperview = Time.timestamp
            
            process()
        }
    }

    @objc
    func bitrise_didMoveToWindow() {
        self.bitrise_didMoveToWindow()
        
        metric.didMoveToWindow = Time.timestamp
    }
    
    // MARK: - Process

    private func process() {
    // Disabled
//        guard !isInternalClass else {
//            metric.observed = false
//
//            return
//        }
//        guard !isBannedClass else {
//            metric.observed = false
//
//            return
//        }
//
//        let formatter = ViewFormatter(metric)
//
//        Trace.shared.queue.add(formatter.metrics)
    }
}

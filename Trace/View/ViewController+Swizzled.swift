//
//  ViewController+Swizzled.swift
//  Trace
//
//  Created by Shams Ahmed on 19/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit
import Foundation
import ObjectiveC

// MARK: - ViewController

fileprivate extension UIViewController {
    
    // MARK: - Trace
    
    /// Generate new trace model
    var generateTrace: TraceModel {
        var name = "\(type(of: self))"
        
        // add view controller title
        if let title = title, !title.isEmpty, title != " " {
            name = "\(title) (\(name))"
        }
        
        let trace = TraceModel.start(with: name)
        
        return trace
    }
}

/// Internal use only
internal extension UIViewController {
    
    // MARK: - Enum
    
    private struct AssociatedKey {
        static var trace = "br_viewController_trace"
        static var foreground = "br_viewController_willEnterForegroundNotification"
    }
    
    // MARK: - Property
    
    var trace: TraceModel {
        get {
            if let trace = objc_getAssociatedObject(self, &AssociatedKey.trace) as? TraceModel {
                return trace
            } else {
                let trace = generateTrace
                
                self.trace = trace
                
                return trace
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.trace, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if !isInternalClass && !isBannedClass {
                let shared = Trace.shared
                
                shared.tracer.traces.append(trace)
                shared.crash.userInfo["Trace Id"] = trace.traceId
            }
        }
    }
    
    var willEnterForegroundNotification: NSObjectProtocol? {
        get {
            let notification = objc_getAssociatedObject(self, &AssociatedKey.foreground) as? NSObjectProtocol
            
            return notification
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.foreground, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let coder = Selectors(
            original: #selector(UIViewController.init(coder:)),
            alternative: #selector(UIViewController.init(bitrise_coder:))
        )
        let nibName = Selectors(
            original: #selector(UIViewController.init(nibName:bundle:)),
            alternative: #selector(UIViewController.init(bitrise_nibName:bundle:))
        )
        let awakeFromNib = Selectors(
            original: #selector(UIViewController.awakeFromNib),
            alternative: #selector(UIViewController.bitrise_awakeFromNib)
        )
        let viewDidLoad = Selectors(
            original: #selector(UIViewController.viewDidLoad),
            alternative: #selector(UIViewController.bitrise_viewDidLoad)
        )
        let viewDidAppear = Selectors(
            original: #selector(UIViewController.viewDidAppear(_:)),
            alternative: #selector(UIViewController.bitrise_viewDidAppear(_:))
        )
        let viewDidDisappear = Selectors(
            original: #selector(UIViewController.viewDidDisappear(_:)),
            alternative: #selector(UIViewController.bitrise_viewDidDisappear(_:))
        )
        let title = Selectors(
            original: #selector(setter: UIViewController.title),
            alternative: #selector(UIViewController.bitrise_title)
        )
        
        _ = self.swizzleInstanceMethod(coder)
        _ = self.swizzleInstanceMethod(nibName)
        _ = self.swizzleInstanceMethod(awakeFromNib)
        _ = self.swizzleInstanceMethod(viewDidLoad)
        _ = self.swizzleInstanceMethod(viewDidAppear)
        _ = self.swizzleInstanceMethod(viewDidDisappear)
        _ = self.swizzleInstanceMethod(title)
        
        return .success
    }
    
    // MARK: - Title
    
    @objc
    func bitrise_title(_ newValue: String?) {
        self.bitrise_title(newValue)
                
        // add view controller title
        if let title = title, !title.isEmpty, title != " " {
            let name = "\(title) (\(type(of: self)))"
            
            trace.root.name.value = name
        }
    }

    // MARK: - Init
    
    @objc
    convenience init?(bitrise_coder aDecoder: NSCoder) {
        self.init(bitrise_coder: aDecoder)
        
        // Should i still create Trace object? would it be better to have a condition
        _ = trace
    }

    @objc
    convenience init(bitrise_nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(bitrise_nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Should i still create Trace object? would it be better to have a condition
        _ = trace
    }
    
    @objc
    func bitrise_awakeFromNib() {
        self.bitrise_awakeFromNib()
        
        // Should i still create Trace object? would it be better to have a condition
        _ = trace
    }

    // MARK: - Load

    @objc
    func bitrise_viewDidLoad() {
        self.bitrise_viewDidLoad()
                
        observePresentation()
    }
    
    // MARK: - Appear

    @objc
    func bitrise_viewDidAppear(_ animated: Bool) {
        observePresentation()
        
        self.bitrise_viewDidAppear(animated)
    }
    
    // MARK: - Disappear

    @objc
    func bitrise_viewDidDisappear(_ animated: Bool) {
        if !isInternalClass && !isBannedClass {
            Trace.shared.tracer.finish(trace)
        }
        
        removeObservingPresentation()
        
        self.bitrise_viewDidDisappear(animated)
    }
    
    // MARK: - Observe
    
    func observePresentation() {
        guard !isInternalClass else { return }
        guard !isBannedClass else { return }
        guard willEnterForegroundNotification == nil else { return }
        
        // Is there a better way?? this could be a expensive operation
        willEnterForegroundNotification = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: nil,
            using: { [weak self] _ in
                if let newTrace = self?.generateTrace {
                    let shared = Trace.shared
                    
                    if let currentTrace = self?.trace {
                        shared.tracer.finish(currentTrace)
                    }
                    
                    self?.trace = newTrace
                }
            }
        )
    }
    
    func removeObservingPresentation() {
        if let notification = willEnterForegroundNotification {
            NotificationCenter.default.removeObserver(notification)
            
            willEnterForegroundNotification = nil
        }
    }
}

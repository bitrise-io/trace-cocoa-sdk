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
        
        let trace = TraceModel.start(with: name, type: .view)
        
        return trace
    }
}

/// Internal use only
extension UIViewController: Swizzled {
    
    // MARK: - Enum
    
    private struct AssociatedKey {
        static var trace = "br_viewController_trace"
        static var foreground = "br_viewController_willEnterForegroundNotification"
    }
    
    // MARK: - Property
    
    var trace: TraceModel? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.trace) as? TraceModel
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.trace, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            // set it as the active trace in tracer
            if let trace = newValue {
                let shared = Trace.shared
                
                shared.tracer.add(trace)
            }
        }
    }
    
    var willEnterForegroundNotification: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.foreground) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.foreground, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        BITRISE_WILL_SWIZZLE_METHOD()
        
        let viewDidLoad = Selectors(
            original: #selector(UIViewController.viewDidLoad),
            alternative: #selector(UIViewController.bitrise_viewDidLoad)
        )
        let viewWillAppear = Selectors(
            original: #selector(UIViewController.viewWillAppear(_:)),
            alternative: #selector(UIViewController.bitrise_viewWillAppear(_:))
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
        
        _ = self.swizzleInstanceMethod(viewDidLoad)
        _ = self.swizzleInstanceMethod(viewWillAppear)
        _ = self.swizzleInstanceMethod(viewDidAppear)
        _ = self.swizzleInstanceMethod(viewDidDisappear)
        _ = self.swizzleInstanceMethod(title)
        
        BITRISE_DID_SWIZZLE_METHOD()
        
        return .success
    }
    
    // MARK: - Title
    
    @objc
    func bitrise_title(_ newValue: String?) {
        self.bitrise_title(newValue)
                
        // add view controller title
        if let title = title, !title.isEmpty, title != " " {
            let name = "\(title) (\(type(of: self)))"
            
            trace?.root.name.value = name
        }
    }

    // MARK: - Load

    @objc
    func bitrise_viewDidLoad() {
        start()
        
        self.bitrise_viewDidLoad()
        
        observePresentation()
    }
    
    // MARK: - Appear
    
    @objc
    func bitrise_viewWillAppear(_ animated: Bool) {
        // Coming back from navigation stack
        if trace == nil || trace?.isComplete == true {
            start()
        }
        
        self.bitrise_viewWillAppear(animated)
    }

    @objc
    func bitrise_viewDidAppear(_ animated: Bool) {
        observePresentation()
        
        self.bitrise_viewDidAppear(animated)
    }
    
    // MARK: - Disappear

    @objc
    func bitrise_viewDidDisappear(_ animated: Bool) {
        stop()
        
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
                Logger.default(.traceModel, "Generating new trace model because the app has come back to foreground")
                
                self?.restart()
            }
        )
    }
    
    func removeObservingPresentation() {
        if let notification = willEnterForegroundNotification {
            NotificationCenter.default.removeObserver(notification)
            
            willEnterForegroundNotification = nil
        }
    }
    
    // MARK: - Start/Stop/Restart
    
    @discardableResult
    func start() -> Bool {
        guard !isInternalClass else { return false }
        guard !isBannedClass else { return false }
        
        trace = generateTrace
        
        return true
    }
    
    @discardableResult
    func stop() -> Bool {
        guard !isInternalClass else { return false }
        guard !isBannedClass else { return false }
        
        var result = false
        
        if let currentTrace = trace {
            let shared = Trace.shared
            
            result = shared.tracer.finish(currentTrace)
            trace = nil
        }
        
        return result
    }
    
    @discardableResult
    func restart() -> Bool {
        guard !isInternalClass else { return false }
        guard !isBannedClass else { return false }
        
        let newTrace = generateTrace
        
        if let trace = trace {
            let shared = Trace.shared
            shared.tracer.finish(trace)
        }
            
        trace = newTrace
        
        return true
    }
}

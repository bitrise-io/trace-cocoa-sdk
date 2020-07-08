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
        static var session = "br_viewController_session"
        static var trace = "br_viewController_trace"
        static var foreground = "br_viewController_willEnterForegroundNotification"
    }
    
    // MARK: - Property
    
    var metric: Metric {
        get {
            if let metric = objc_getAssociatedObject(self, &AssociatedKey.session) as? Metric {
                return metric
            } else {
                let metric = Metric()
                metric.name = "\(type(of: self))"
                
                self.metric = metric
                
                return metric
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.session, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
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
        let loadView = Selectors(
            original: #selector(UIViewController.loadView),
            alternative: #selector(UIViewController.bitrise_loadView)
        )
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
        let viewWillLayoutSubviews = Selectors(
            original: #selector(UIViewController.viewWillLayoutSubviews),
            alternative: #selector(UIViewController.bitrise_viewWillLayoutSubviews)
        )
        let viewDidLayoutSubviews = Selectors(
            original: #selector(UIViewController.viewDidLayoutSubviews),
            alternative: #selector(UIViewController.bitrise_viewDidLayoutSubviews)
        )
        let viewWillDisappear = Selectors(
            original: #selector(UIViewController.viewWillDisappear(_:)),
            alternative: #selector(UIViewController.bitrise_viewWillDisappear(_:))
        )
        let viewDidDisappear = Selectors(
            original: #selector(UIViewController.viewDidDisappear(_:)),
            alternative: #selector(UIViewController.bitrise_viewDidDisappear(_:))
        )
        let didReceiveMemoryWarning = Selectors(
            original: #selector(UIViewController.didReceiveMemoryWarning),
            alternative: #selector(UIViewController.bitrise_didReceiveMemoryWarning)
        )
        let title = Selectors(
            original: #selector(setter: UIViewController.title),
            alternative: #selector(UIViewController.bitrise_title)
        )
        
        _ = self.swizzleInstanceMethod(coder)
        _ = self.swizzleInstanceMethod(nibName)
        _ = self.swizzleInstanceMethod(awakeFromNib)
        _ = self.swizzleInstanceMethod(loadView)
        _ = self.swizzleInstanceMethod(viewDidLoad)
        _ = self.swizzleInstanceMethod(viewWillAppear)
        _ = self.swizzleInstanceMethod(viewDidAppear)
        _ = self.swizzleInstanceMethod(viewWillLayoutSubviews)
        _ = self.swizzleInstanceMethod(viewDidLayoutSubviews)
        _ = self.swizzleInstanceMethod(viewWillDisappear)
        _ = self.swizzleInstanceMethod(viewDidDisappear)
        _ = self.swizzleInstanceMethod(didReceiveMemoryWarning)
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
        
        metric.initWithCoder = Time.timestamp
    }

    @objc
    convenience init(bitrise_nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(bitrise_nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Should i still create Trace object? would it be better to have a condition
        _ = trace
        
        metric.initWithNib = Time.timestamp
    }
    
    @objc
    func bitrise_awakeFromNib() {
        self.bitrise_awakeFromNib()
        
        // Should i still create Trace object? would it be better to have a condition
        _ = trace
        
        metric.awakeFromNib = Time.timestamp
    }

    // MARK: - Load
    
    @objc
    func bitrise_loadView() {
        self.bitrise_loadView()
        
        metric.loadView = Time.timestamp
    }

    @objc
    func bitrise_viewDidLoad() {
        self.bitrise_viewDidLoad()
        
        metric.viewDidLoad = Time.timestamp
        
        observePresentation()
    }
    
    // MARK: - Appear

    @objc
    func bitrise_viewWillAppear(_ animated: Bool) {
        self.bitrise_viewWillAppear(animated)
        
        metric.viewWillAppear = Time.timestamp
    }

    @objc
    func bitrise_viewWillLayoutSubviews() {
        self.bitrise_viewWillLayoutSubviews()
        
        metric.viewWillLayoutSubviews = Time.timestamp
    }

    @objc
    func bitrise_viewDidLayoutSubviews() {
        self.bitrise_viewDidLayoutSubviews()
        
        metric.viewDidLayoutSubviews = Time.timestamp
    }

    @objc
    func bitrise_viewDidAppear(_ animated: Bool) {
        observePresentation()
        
        self.bitrise_viewDidAppear(animated)
        
        if metric.viewDidAppear == nil {
            metric.viewDidAppear = Time.timestamp
            
            process()
        }
    }
    
    // MARK: - Disappear

    @objc
    func bitrise_viewWillDisappear(_ animated: Bool) {
        self.bitrise_viewWillDisappear(animated)
        
        metric.viewWillDisappear = Time.timestamp
    }

    @objc
    func bitrise_viewDidDisappear(_ animated: Bool) {
        if !isInternalClass && !isBannedClass {
            Trace.shared.tracer.finish(trace)
        }
        
        removeObservingPresentation()
        
        self.bitrise_viewDidDisappear(animated)
        
        if metric.viewDidDisappear == nil {
            metric.viewDidDisappear = Time.timestamp
            
            process()
        }
    }
    
    // MARK: - Warning

    @objc
    func bitrise_didReceiveMemoryWarning() {
        self.bitrise_didReceiveMemoryWarning()
        
        if metric.didReceiveMemoryWarning == nil {
            metric.didReceiveMemoryWarning = Time.timestamp
            
            process()
        }
    }
    
    // MARK: - Process
    
    private func process() {
        guard !isInternalClass else {
            metric.observed = false
            
            return
        }
        guard !isBannedClass else {
            metric.observed = false
            
            return
        }
        
        let formatter = ViewControllerFormatter(metric)
        
        Trace.shared.queue.add(formatter.metrics)
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

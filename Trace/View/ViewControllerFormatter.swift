//
//  ViewControllerFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 20/06/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import UIKit

internal struct ViewControllerFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case name = "view.name"
        case event
        case `init` = "init"
        case loadView = "load.view"
        case viewDidLoad = "view.did.load"
        case viewWillAppear = "view.will.appear"
        case viewDidAppear = "view.did.appear"
        case viewWillLayoutSubviews = "view.will.layout.subviews"
        case viewDidLayoutSubviews = "view.did.layout.subviews"
        case viewWillDisappear = "view.will.disappear"
        case viewDidDisappear = "view.did.disappear"
    }
    
    // MARK: - Property
    
    internal let metric: UIViewController.Metric
    
    // MARK: - Init
    
    internal init(_ metric: UIViewController.Metric) {
        self.metric = metric
       
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        var details = OrderedDictionary<String, String>()
        
        if let value = metric.`init`.jsonString() {
            details[Keys.`init`.rawValue] = value
        } else if let value = metric.initWithCoder.jsonString() {
            details[Keys.`init`.rawValue] = value
        } else if let value = metric.initWithNib.jsonString() {
            details[Keys.`init`.rawValue] = value
        } else if let value = metric.awakeFromNib.jsonString() {
            details[Keys.`init`.rawValue] = value
        }

        details[Keys.name.rawValue] = metric.name
        
        if let value = metric.loadView.jsonString() {
            details[Keys.loadView.rawValue] = value
        }
        
        if let value = metric.viewDidLoad.jsonString() {
            details[Keys.viewDidLoad.rawValue] = value
        }
        
        if let value = metric.viewWillAppear.jsonString() {
            details[Keys.viewWillAppear.rawValue] = value
        }
        
        if let value = metric.viewDidAppear.jsonString() {
            details[Keys.viewDidAppear.rawValue] = value
        }
        
        if let value = metric.viewWillLayoutSubviews.jsonString() {
            details[Keys.viewWillLayoutSubviews.rawValue] = value
        }
        
        if let value = metric.viewDidLayoutSubviews.jsonString() {
            details[Keys.viewDidLayoutSubviews.rawValue] = value
        }
        
        if let value = metric.viewWillDisappear.jsonString() {
            details[Keys.viewWillDisappear.rawValue] = value
        }
        
        if let value = metric.viewDidDisappear.jsonString() {
            details[Keys.viewDidDisappear.rawValue] = value
        }
        
        return details
    }
}

extension ViewControllerFormatter: Metricable {
    
    // MARK: - Metric
    
    internal var metrics: Metrics {
        var timeseries = [Metric.Timeseries]()
        let duration = metric.viewRenderingLatency.rounded(to: 2)
        
        if let value = metric.`init` {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.`init`.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        } else if let value = metric.initWithCoder {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.`init`.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        } else if let value = metric.initWithNib {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.`init`.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        } else if let value = metric.awakeFromNib {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.`init`.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.loadView {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.loadView.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.viewDidLoad {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.viewDidLoad.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.viewWillAppear {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.viewWillAppear.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.viewDidAppear {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.viewDidAppear.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.viewWillLayoutSubviews {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.viewWillLayoutSubviews.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.viewDidLayoutSubviews {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.viewDidLayoutSubviews.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.viewWillDisappear {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.viewWillDisappear.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.viewDidDisappear {
            timeseries.append(Metric.Timeseries(
                [.value(self.metric.name), .value(Keys.viewDidDisappear.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        let descriptor = Metric.Descriptor(
            name: .appRequestSizeBytes,
            description: "View controller render latency in milliseconds",
            unit: .ms,
            type: .int64,
            keys: [.init(Keys.name.rawValue), .init(Keys.event.rawValue)]
        )
        let metric = Metric(descriptor: descriptor, timeseries: timeseries)
        
        return Metrics([metric])
    }
}

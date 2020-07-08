//
//  ViewFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 20/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import UIKit

internal struct ViewFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case event
        case name = "view.name"
        case `init` = "init"
        case layoutSubviews = "layout.subviews"
        case draw = "draw"
        case didMoveToSuperview = "did.move.to.superview"
        case removeFromSuperview = "remove.from.superview"
    }
    
    // MARK: - Property
    
    private let metric: UIView.Metric
    
    // MARK: - Init
    
    internal init(_ metric: UIView.Metric) {
        self.metric = metric
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        var `init` = ""
        
        if let initWithX = metric.initWithCoder.jsonString() ?? metric.initWithFrame.jsonString() {
            `init` = initWithX
        }
        
        var details = OrderedDictionary<String, String>()
        details[Keys.name.rawValue] = metric.name
        details[Keys.`init`.rawValue] = `init`
        details[Keys.layoutSubviews.rawValue] = metric.layoutSubviews.jsonString() ?? ""
        details[Keys.draw.rawValue] = metric.draw.jsonString() ?? ""
        details[Keys.didMoveToSuperview.rawValue] = metric.didMoveToSuperview.jsonString() ?? ""
        details[Keys.removeFromSuperview.rawValue] = metric.removeFromSuperview.jsonString() ?? ""
        
        return details.compactMapValues { $0 }
    }
}

extension ViewFormatter: Metricable {
    
    // MARK: - Metric
    
    internal var metrics: Metrics {
        let name = self.metric.name
        let duration = metric.duration.rounded(to: 2)
        var timeseries = [Metric.Timeseries]()
        
        if let value = metric.initWithCoder {
            timeseries.append(Metric.Timeseries(
                [.value(name), .value(Keys.`init`.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        } else if let value = metric.initWithFrame {
            timeseries.append(Metric.Timeseries(
                [.value(name), .value(Keys.`init`.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.layoutSubviews {
            timeseries.append(Metric.Timeseries(
                [.value(name), .value(Keys.layoutSubviews.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.draw {
            timeseries.append(Metric.Timeseries(
                [.value(name), .value(Keys.draw.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.didMoveToSuperview {
            timeseries.append(Metric.Timeseries(
                [.value(name), .value(Keys.didMoveToSuperview.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        if let value = metric.removeFromSuperview {
            timeseries.append(Metric.Timeseries(
                [.value(name), .value(Keys.removeFromSuperview.rawValue)],
                points: [.point(seconds: value.seconds, nanos: value.nanos, value: duration)])
            )
        }
        
        let descriptor = Metric.Descriptor(
            name: .subviewRenderLatencyMS,
            description: "View render latency in milliseconds",
            unit: .ms,
            type: .int64,
            keys: [.init(Keys.name.rawValue), .init(Keys.event.rawValue)]
        )
        let metric = Metric(descriptor: descriptor, timeseries: timeseries)
        
        return Metrics([metric])
    }
}

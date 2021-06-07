//
//  CrashFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 07/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal struct CrashFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case type
        case name
        case reason
        case crashType = "crash.type"
        case crashReason = "crash.reason"
    }
    
    // MARK: - Property
    
    private let report: CrashReporting.Report
    
    // MARK: - Init
    
    internal init(_ report: CrashReporting.Report) {
        self.report = report
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        return [
            Keys.type.rawValue: report.type.rawValue,
            Keys.name.rawValue: report.name,
            Keys.reason.rawValue: report.reason
        ]
    }
}

extension CrashFormatter: Metricable {
    
    // MARK: - Metric
    
    internal var metrics: Metrics {
        let timeseries = Metric.Timeseries(
            [.value(report.name)],
            points: [.point(seconds: report.timestamp.seconds, nanos: report.timestamp.nanos, value: 1)]
        )
        let descriptor = Metric.Descriptor(
            name: .appCrashTotal,
            description: "Total number of application crashes",
            unit: .one,
            type: .cumulativeInt64,
            keys: [.init(Keys.crashType.rawValue)]
        )
        let metric = Metric(descriptor: descriptor, timeseries: timeseries)
        
        return Metrics([metric])
    }
}

extension CrashFormatter: Spanable {
    
    // MARK: - Spans
    
    var spans: [TraceModel.Span] {
        let name = TraceModel.Span.Name(value: report.name, truncatedByteCount: 0)
        let start = TraceModel.Span.Timestamp(seconds: report.timestamp.seconds, nanos: report.timestamp.nanos)
        let attribute = TraceModel.Span.Attributes(attributes: [
            TraceModel.Span.Attributes.Attribute(name: Keys.type.rawValue, value: .init(value: report.type.rawValue, truncatedByteCount: 0)),
            TraceModel.Span.Attributes.Attribute(name: Keys.reason.rawValue, value: .init(value: report.reason, truncatedByteCount: 0))
        ])
        let timestamp = Time.timestamp
        let end = TraceModel.Span.Timestamp(seconds: timestamp.seconds, nanos: timestamp.nanos)
        let span = TraceModel.Span(name: name, start: start, end: end, attribute: attribute)
        
        return [span]
    }
}

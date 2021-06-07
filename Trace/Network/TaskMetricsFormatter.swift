//
//  TaskMetricsFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 11/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

protocol URLSessionTaskMetricsReadable {
    
    var transactionMetricsReadable: [URLSessionTaskTransactionMetricsReadable] { get }
    var taskInterval: DateInterval { get }
    var redirectCount: Int { get }
}

protocol URLSessionTaskTransactionMetricsReadable {
    
    // MARK: - Property
    
    var request: URLRequest { get }
    var response: URLResponse? { get }
    var fetchStartDate: Date? { get }
    var domainLookupStartDate: Date? { get }
    var domainLookupEndDate: Date? { get }
    var connectStartDate: Date? { get }
    var secureConnectionStartDate: Date? { get }
    var secureConnectionEndDate: Date? { get }
    var connectEndDate: Date? { get }
    var requestStartDate: Date? { get }
    var requestEndDate: Date? { get }
    var responseStartDate: Date? { get }
    var responseEndDate: Date? { get }
    var networkProtocolName: String? { get }
    var isProxyConnection: Bool { get }
    var isReusedConnection: Bool { get }
    var resourceFetchType: URLSessionTaskMetrics.ResourceFetchType { get }
}

extension URLSessionTaskTransactionMetrics: URLSessionTaskTransactionMetricsReadable { }

extension URLSessionTaskMetrics: URLSessionTaskMetricsReadable {
    
    // MARK: - Property
    
    var transactionMetricsReadable: [URLSessionTaskTransactionMetricsReadable] {
        return self.transactionMetrics
    }
}

internal struct TaskMetricsFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case taskInterval = "task.interval"
        case taskIntervalDuration = "task.interval.duration"
        case redirectCount = "redirect.count"
        case response = "response"
        case request = "request"
        case connect = "connect"
        case domainLookup = "domain.lookup"
        case secureConnection = "secure.connection"
        case statusCode = "http.status_code"
        case url = "http.url"
        case method = "http.method"
        case size // get removed when submitting metrics
    }
    
    // MARK: - Property
    
    private let taskMetrics: URLSessionTaskMetricsReadable
    private let timestamp = Time.timestamp
    
    // MARK: - Init
    
    internal init(_ taskMetrics: URLSessionTaskMetricsReadable) {
        self.taskMetrics = taskMetrics
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Details
    
    internal var details: OrderedDictionary<String, String> {
        var detail = detailsForRequest
        detail.merge(detailsForResponse)
        detail.merge(detailsForLatency)
        
        return OrderedDictionary<String, String>(uniqueKeysWithValues: detail)
    }
    
    private var detailsForLatency: OrderedDictionary<String, String> {
        var details = OrderedDictionary<String, String>()
        
        let taskInterval = (taskMetrics.taskInterval.end.timeIntervalSinceReferenceDate - taskMetrics.taskInterval.start.timeIntervalSinceReferenceDate) * 1000
        
        details[Keys.taskInterval.rawValue] = String(taskInterval.rounded(to: 1))
        details[Keys.taskIntervalDuration.rawValue] = String(taskMetrics.taskInterval.duration.rounded(to: 1))
        details[Keys.redirectCount.rawValue] = String(taskMetrics.redirectCount)
        
        if let transaction = taskMetrics.transactionMetricsReadable.first {
            if let end = transaction.responseEndDate, let start = transaction.responseStartDate {
                let response = (end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate) * 1000
                
                details[Keys.response.rawValue] = String(response.rounded(to: 2))
            }
            
            if let end = transaction.requestEndDate, let start = transaction.requestStartDate {
                let request = (end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate) * 1000
                
                details[Keys.request.rawValue] = String(request.rounded(to: 2))
            }
            
            if let end = transaction.connectEndDate, let start = transaction.connectStartDate {
                let connect = (end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate) * 1000
                
                details[Keys.connect.rawValue] = String(connect.rounded(to: 2))
            }
            
            if let start = transaction.domainLookupStartDate, let end = transaction.domainLookupEndDate {
                let domainLookup = (end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate) * 1000
                
                details[Keys.domainLookup.rawValue] = String(domainLookup.rounded(to: 2))
            }
            
            if let start = transaction.secureConnectionStartDate, let end = transaction.secureConnectionEndDate {
                let connection = (end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate) * 1000
                
                details[Keys.secureConnection.rawValue] = String(connection.rounded(to: 2))
            }
            
            if let response = transaction.response as? HTTPURLResponse {
                details[Keys.method.rawValue] = transaction.request.httpMethod
                details[Keys.statusCode.rawValue] = String(response.statusCode)
                details[Keys.size.rawValue] = String(response.expectedContentLength)
                
                let url = response.url
                let urlStructure = URLStructure(url: url)
                    
                details[Keys.url.rawValue] = urlStructure.format() ?? "Unknown"
            }
        }
        
        return details
    }

    private var detailsForResponse: OrderedDictionary<String, String> {
        var details = OrderedDictionary<String, String>()
        
        if let transaction = taskMetrics.transactionMetricsReadable.first {
            if let response = transaction.response as? HTTPURLResponse {
                details[Keys.method.rawValue] = transaction.request.httpMethod
                details[Keys.statusCode.rawValue] = String(response.statusCode)
                details[Keys.size.rawValue] = String(response.expectedContentLength)
                
                let url = response.url
                let urlStructure = URLStructure(url: url)
                
                details[Keys.url.rawValue] = urlStructure.format() ?? "Unknown"
            }
        }
        
        return details
    }
    
    private var detailsForRequest: OrderedDictionary<String, String> {
        var details = OrderedDictionary<String, String>()
        
        if let transaction = taskMetrics.transactionMetricsReadable.first {
            let url = transaction.request.url
            let urlStructure = URLStructure(url: url)
            
            details[Keys.url.rawValue] = urlStructure.format() ?? "Unknown"
            details[Keys.method.rawValue] = transaction.request.httpMethod ?? "Unknown"
            details[Keys.size.rawValue] = String(transaction.request.httpBody?.count ?? 0)
            
            if let response = transaction.response as? HTTPURLResponse {
                details[Keys.statusCode.rawValue] = String(response.statusCode)
            }
        }
        
        return details
    }
}

extension TaskMetricsFormatter: Metricable {
    
    // MARK: - Metric
    
    var metrics: Metrics {
        var requestDetail = detailsForRequest
        var responseDetail = detailsForResponse
        let requestPointValue = Double(requestDetail[Keys.size.rawValue] ?? "0") ?? 0
        let responsePointValue = Double(responseDetail[Keys.size.rawValue] ?? "0") ?? 0
        
        requestDetail.removeValue(forKey: Keys.size.rawValue)
        responseDetail.removeValue(forKey: Keys.size.rawValue)
        
        let request = metric(
            for: .appRequestSizeBytes,
            description: "Network request size in bytes",
            unit: .bytes,
            type: .int64,
            detail: requestDetail,
            points: [.point(seconds: timestamp.seconds, nanos: timestamp.nanos, value: requestPointValue)]
        )
        let response = metric(
            for: .appResponseSizeBytes,
            description: "Network response size in bytes",
            unit: .bytes,
            type: .int64,
            detail: responseDetail,
            points: [.point(seconds: timestamp.seconds, nanos: timestamp.nanos, value: responsePointValue)]
        )
        
        return Metrics([request, response])
    }
}

extension TaskMetricsFormatter: Spanable {
    
    // MARK: - Enum
    
    private enum CodingKeys: String {
        case url = "http.url"
        case latency = "http.latency"
        case statusCode = "http.status_code"
        case responseSize = "http.response.size"
        case requestSize = "http.request.size"
        case method = "http.method"
    }
    
    // MARK: - Spans
    
    var spans: [TraceModel.Span] {
        guard let transaction = taskMetrics.transactionMetricsReadable.first else { return [] }
        guard let fetchStartDate = transaction.fetchStartDate else { return [] }
        guard let url = URLStructure(url: transaction.request.url).format() else { return [] }
        
        let latency = String(taskMetrics.taskInterval.duration.rounded(to: 1))
        let requestSize = String(transaction.request.httpBody?.count ?? 0)
        
        var attributes = [TraceModel.Span.Attributes.Attribute]()
        attributes.append(.init(
            name: CodingKeys.url.rawValue,
            value: .init(value: url, truncatedByteCount: 0))
        )
        
        if let method = transaction.request.httpMethod {
            attributes.append(.init(
                name: CodingKeys.method.rawValue,
                value: .init(value: method, truncatedByteCount: 0))
            )
        }
        
        attributes.append(.init(
            name: CodingKeys.latency.rawValue,
            value: .init(value: latency, truncatedByteCount: 0))
        )
        attributes.append(.init(
            name: CodingKeys.requestSize.rawValue,
            value: .init(value: requestSize, truncatedByteCount: 0))
        )
        
        if let response = transaction.response as? HTTPURLResponse {
            let statusCode = String(response.statusCode)
            let responseSize = String(response.expectedContentLength)
                
            attributes.append(.init(
                name: CodingKeys.statusCode.rawValue,
                value: .init(value: statusCode, truncatedByteCount: 0))
            )
            attributes.append(.init(
                name: CodingKeys.responseSize.rawValue,
                value: .init(value: responseSize, truncatedByteCount: 0))
            )
        }
        
        let attributeWrapper = TraceModel.Span.Attributes(attributes: attributes)
        let startFormatted = Time.from(fetchStartDate)
        let start = TraceModel.Span.Timestamp(seconds: startFormatted.seconds, nanos: startFormatted.nanos)
        let end = TraceModel.Span.Timestamp(seconds: timestamp.seconds, nanos: timestamp.nanos)
        let span = TraceModel.Span(
            name: TraceModel.Span.Name(value: url, truncatedByteCount: 0),
            start: start,
            end: end,
            attribute: attributeWrapper
        )

        return [span]
    }
}

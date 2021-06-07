//
//  URLSessionTaskFormatter.swift
//  Trace
//
//  Created by Shams Ahmed on 24/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

protocol URLSessionTaskReadable {
    
    // MARK: - Property
    
    var originalRequest: URLRequest? { get }
    var response: URLResponse? { get }
    var countOfBytesReceived: Int64 { get }
    var iOS10_countOfBytesClientExpectsToSend: Int64 { get }
    var countOfBytesExpectedToSend: Int64 { get }
    
    // MARK: - Property - Custom via Runtime
    
    var startDate: Time.Timestamp? { get }
    var endDate: Time.Timestamp? { get }
}

extension URLSessionTask: URLSessionTaskReadable {
    
    // MARK: - Property
    
    var iOS10_countOfBytesClientExpectsToSend: Int64 {
        var result = NSURLSessionTransferSizeUnknown
        
        if #available(iOS 11.0, *) {
            result = countOfBytesClientExpectsToSend
        }
        
        return result
    }
}

internal struct URLSessionTaskFormatter: JSONEncodable {
    
    // MARK: - Enum
    
    private enum Keys: String {
        case url = "http.url"
        case method = "http.method"
        case size
        case statusCode = "http.status_code"
    }
    
    // MARK: - Property
    
    private let task: URLSessionTaskReadable
    private let timestamp = Time.timestamp
    
    // MARK: - Init
    
    internal init(_ task: URLSessionTaskReadable) {
        self.task = task
        
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
        
        if let request = task.originalRequest {
            let urlStructure = URLStructure(url: request.url)
            
            details[Keys.url.rawValue] = urlStructure.format() ?? "Unknown"
            details[Keys.method.rawValue] = request.httpMethod
        }
        
        if let response = task.response as? HTTPURLResponse {
            details[Keys.statusCode.rawValue] = String(response.statusCode)
        }
        
        let countOfBytesClientExpectsToSend = task.iOS10_countOfBytesClientExpectsToSend
        
        if countOfBytesClientExpectsToSend != NSURLSessionTransferSizeUnknown {
            details[Keys.size.rawValue] = String(countOfBytesClientExpectsToSend)
        } else {
            details[Keys.size.rawValue] = String(task.countOfBytesExpectedToSend)
        }
        
        return details
    }
    
    private var detailsForResponse: OrderedDictionary<String, String> {
        var details = OrderedDictionary<String, String>()
        
        if let request = task.originalRequest {
            let urlStructure = URLStructure(url: request.url)
            
            details[Keys.url.rawValue] = urlStructure.format() ?? "Unknown"
            details[Keys.method.rawValue] = request.httpMethod
        }
        
        if let response = task.response as? HTTPURLResponse {
            details[Keys.statusCode.rawValue] = String(response.statusCode)
        }
        
        details[Keys.size.rawValue] = String(task.countOfBytesReceived)
        
        return details
    }
    
    private var detailsForRequest: OrderedDictionary<String, String> {
        var details = OrderedDictionary<String, String>()
        
        if let request = task.originalRequest {
            let url = request.url
            let urlStructure = URLStructure(url: url)
            
            details[Keys.url.rawValue] = urlStructure.format() ?? "Unknown"
            details[Keys.method.rawValue] = request.httpMethod ?? "Unknown"
        }
        
        let countOfBytesClientExpectsToSend = task.iOS10_countOfBytesClientExpectsToSend
        
        if countOfBytesClientExpectsToSend != NSURLSessionTransferSizeUnknown {
            details[Keys.size.rawValue] = String(countOfBytesClientExpectsToSend)
        } else {
            details[Keys.size.rawValue] = String(task.countOfBytesExpectedToSend)
        }
        
        if let response = task.response as? HTTPURLResponse {
            details[Keys.statusCode.rawValue] = String(response.statusCode)
        }
        
        return details
    }
}

extension URLSessionTaskFormatter: Metricable {
    
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

extension URLSessionTaskFormatter: Spanable {
    
    // MARK: - Enums
    
    private enum CodingKeys: String {
        case url = "http.url"
        case latency = "http.latency"
        case statusCode = "http.status_code"
        case responseSize = "http.response.size"
        case requestSize = "http.request.size"
        case method = "http.method"
    }
    
    // MARK: - Spanable

    var spans: [TraceModel.Span] {
        guard let startDate = task.startDate else {
            Logger.debug(.network, "Start date in Task has not been set")
            
            return []
        }
        guard let url = URLStructure(url: task.originalRequest?.url).format() else { return [] }
        
        let detail = detailsForRequest
        let responseSize = String(task.countOfBytesReceived)
        
        var attributes = [TraceModel.Span.Attributes.Attribute]()
        attributes.append(.init(
            name: CodingKeys.url.rawValue,
            value: .init(value: url, truncatedByteCount: 0))
        )
        attributes.append(.init(
            name: CodingKeys.responseSize.rawValue,
            value: .init(value: responseSize, truncatedByteCount: 0))
        )
        
        if let method = task.originalRequest?.httpMethod {
            attributes.append(.init(
                name: CodingKeys.method.rawValue,
                value: .init(value: method, truncatedByteCount: 0))
            )
        }
        
        if let requestSize = detail[Keys.size.rawValue] {
            attributes.append(.init(
                name: CodingKeys.requestSize.rawValue,
                value: .init(value: requestSize, truncatedByteCount: 0))
            )
        }
        
        if let response = task.response as? HTTPURLResponse {
            let statusCode = String(response.statusCode)
            
            attributes.append(.init(
                name: CodingKeys.statusCode.rawValue,
                value: .init(value: statusCode, truncatedByteCount: 0))
            )
        }
        
        let latency: Double
        
        if let end = task.endDate?.timeInterval {
            let result = end - startDate.timeInterval
            
            latency = result.rounded(to: 2)
        } else {
            latency = -1
        }
        
        attributes.append(.init(
            name: CodingKeys.latency.rawValue,
            value: .init(value: String(latency), truncatedByteCount: 0))
        )
        
        let attributeWrapper = TraceModel.Span.Attributes(attributes: attributes)
        let start = TraceModel.Span.Timestamp(seconds: startDate.seconds, nanos: startDate.nanos)
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

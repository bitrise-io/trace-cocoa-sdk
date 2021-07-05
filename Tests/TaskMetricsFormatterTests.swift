//
//  TaskMetricsFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class TaskMetricsFormatterTests: XCTestCase {
    
    // MARK: - Mock
    
    class MockTransactionMetric: URLSessionTaskTransactionMetricsReadable {
        
        // MARK: - Property
        
        var request: URLRequest = URLRequest(url: URL(string: "https://bitrise.io")!)
        var response: URLResponse? = HTTPURLResponse(
            url: URL(string: "https://bitrise.io")!,
            mimeType: "jpg",
            expectedContentLength: 12131,
            textEncodingName: "utf8"
        )
        var fetchStartDate: Date? = Date()
        var domainLookupStartDate: Date? = Date()
        var domainLookupEndDate: Date? = Date()
        var connectStartDate: Date? = Date()
        var secureConnectionStartDate: Date? = Date()
        var secureConnectionEndDate: Date? = Date()
        var connectEndDate: Date? = Date()
        var requestStartDate: Date? = Date()
        var requestEndDate: Date? = Date()
        var responseStartDate: Date? = Date()
        var responseEndDate: Date? = Date()
        var networkProtocolName: String? = ""
        var isProxyConnection: Bool = true
        var isReusedConnection: Bool = true
        var resourceFetchType: URLSessionTaskMetrics.ResourceFetchType  = .networkLoad
    }
    
    class MockMetrics: URLSessionTaskMetricsReadable {
        
        // MARK: - Property
        
        var transactionMetricsReadable: [URLSessionTaskTransactionMetricsReadable] = [
            MockTransactionMetric()
        ]
        
        var taskInterval: DateInterval = DateInterval(start: Date(), duration: 20.0)
        var redirectCount: Int = 0
    }
    
    // MARK: - Property
    
    let mock = MockMetrics()
    lazy var taskMetrics = TaskMetricsFormatter(mock)
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(taskMetrics)
        XCTAssertNotNil(taskMetrics.data)
        XCTAssertNotNil(taskMetrics.jsonString)
    }

    func testReadMetrics() {
        let metrics = taskMetrics.metrics

        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        XCTAssertNotNil(taskMetrics.details)

        XCTAssertEqual(metrics.metrics.count, 2)
    }

    func testReadMetrics_readOne() {
        let metric = taskMetrics.metrics.metrics.first!

        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.appRequestSizeBytes)

        XCTAssertEqual(metric.timeseries.count, 1)
        XCTAssertNotNil(taskMetrics.details)
    }

    func testReadMetrics_readPoints() {
        let points = taskMetrics.metrics.metrics.first!.timeseries[0].points
        let point = taskMetrics.metrics.metrics.first!.timeseries[0].points[0]

        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }

    func testReadMetrics_readValues() {
        let values = taskMetrics.metrics.metrics.first!.timeseries[0].values
        let value = taskMetrics.metrics.metrics.first!.timeseries[0].values[0]

        XCTAssertEqual(values.count, 3)
        XCTAssertTrue(value.hasValue)
    }
    
    func testSpans_retunsValue() {
        let spans = taskMetrics.spans
        
        XCTAssertEqual(spans.count, 1)
       
        let span = spans[0]
        let statusCode = span.attribute.attribute.first { $0.key == "http.status_code" }
        let url = span.attribute.attribute.first { $0.key == "http.url" }
        let method = span.attribute.attribute.first { $0.key == "http.method" }
        
        XCTAssertNil(span.traceId)
        XCTAssertNotNil(span.spanId)
        XCTAssertNil(span.parentSpanId)
        XCTAssertNotNil(span.end)
        XCTAssertEqual(span.attribute.attribute.count, 6)
        
        XCTAssertNotNil(statusCode)
        XCTAssertNotNil(url)
        XCTAssertNotNil(method)
    }
  
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: taskMetrics.metrics.metrics[0].descriptor, as: .json)
    }
    
    func testDescriptor_snapshot() {
        let formatter = TaskMetricsFormatter(mock)
        let metric = formatter.metrics.metrics.first!
        
        assertSnapshot(matching: metric.descriptor, as: .json)
    }
}

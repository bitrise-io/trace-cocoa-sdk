//
//  URLSessionTaskFormatterTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Trace

final class URLSessionTaskFormatterTests: XCTestCase {
    
    // MARK: - Mock
    
    class MockURLSessionTask: URLSessionTaskReadable {
        
        // MARK: - Property
        
        var originalRequest: URLRequest?
        
        var response: URLResponse? { return HTTPURLResponse(
            url: URL(string: "https://bitrise.io")!,
            statusCode: 200,
            httpVersion: "v1.1",
            headerFields: [:]
            )
        }
        var countOfBytesReceived: Int64 { return 123 }
        var iOS10_countOfBytesClientExpectsToSend: Int64 { return 123 }
        var countOfBytesExpectedToSend: Int64 { return 123 }
        var startDate: Time.Timestamp? { return Time.timestamp }
        var endDate: Time.Timestamp?
        
        // MARK: - Init
        
        init(url: URL, endDate: Time.Timestamp? = nil) {
            self.originalRequest = URLRequest(url: url)
            self.endDate = endDate
        }
    }
    
    // MARK: - Property
    
    let task: URLSessionTaskFormatter = {
        let url = URL(string: "https://bitrise.io")!
        let session = URLSession(
            configuration: .ephemeral,
            delegate: nil,
            delegateQueue: nil
        )
        let task = session.dataTask(with: url) { _, _, _ in }
        let formatter = URLSessionTaskFormatter(task)
        
        return formatter
    }()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testErrorNil() {
        XCTAssertNotNil(task)
        XCTAssertNotNil(task.data)
        XCTAssertNotNil(task.jsonString)
    }
    
    func testReadMetrics() {
        let metrics = task.metrics
        
        XCTAssertNotNil(metrics)
        XCTAssertNil(metrics.resource)
        XCTAssertNotNil(task.details)
        
        XCTAssertEqual(metrics.metrics.count, 2)
    }
    
    func testReadMetrics_readOne() {
        let metric = task.metrics.metrics.first!
        
        XCTAssertNotNil(metric)
        XCTAssertNotNil(metric.descriptor)
        XCTAssertNotNil(metric.timeseries)
        XCTAssertEqual(metric.descriptor.name, Metric.Descriptor.Name.appRequestSizeBytes)
        
        XCTAssertEqual(metric.timeseries.count, 1)
        XCTAssertNotNil(task.details)
    }
    
    func testReadMetrics_readPoints() {
        let points = task.metrics.metrics.first!.timeseries[0].points
        let point = task.metrics.metrics.first!.timeseries[0].points[0]
        
        XCTAssertEqual(points.count, 1)
        XCTAssertNotNil(point)
    }
    
    func testReadMetrics_readValues() {
        let values = task.metrics.metrics.first!.timeseries[0].values
        let value = task.metrics.metrics.first!.timeseries[0].values[0]
        
        XCTAssertEqual(values.count, 2)
        XCTAssertTrue(value.hasValue)
    }
    
    func testSpans_retunsZero() {
        let spans = task.spans
        
        XCTAssertEqual(spans.count, 0)
    }
    
    func testSpans_retunsSpan() {
        let task = MockURLSessionTask(url: URL(string: "https://bitrise.io")!)
        let formatter = URLSessionTaskFormatter(task)
        
        XCTAssertEqual(formatter.spans.count, 1)
        
        let span = formatter.spans[0]
        
        XCTAssertNil(span.traceId)
        XCTAssertNotNil(span.spanId)
        XCTAssertNil(span.parentSpanId)
        XCTAssertNotNil(span.end)
    }
    
    func testSpans_noEndDate() {
        let task = MockURLSessionTask(url:  URL(string: "https://bitrise.io")!, endDate: Time.timestamp)
        let formatter = URLSessionTaskFormatter(task)
        
        XCTAssertEqual(formatter.spans.count, 1)
        
        let span = formatter.spans[0]
        
        XCTAssertNil(span.traceId)
        XCTAssertNotNil(span.spanId)
        XCTAssertNil(span.parentSpanId)
        XCTAssertNotNil(span.end)
        XCTAssertEqual(span.attribute.attribute.count, 6)
    }
    
    func testSpans_badURL() {
        let task = MockURLSessionTask(url:  URL(string: "bitrise..io")!)
        let formatter = URLSessionTaskFormatter(task)
        
        XCTAssertEqual(formatter.spans.count, 1)
    }
    
    func testSpans_goodURL() {
        let task = MockURLSessionTask(url:  URL(string: "https://www.bitrise.io")!)
        let formatter = URLSessionTaskFormatter(task)
        
        XCTAssertEqual(formatter.spans.count, 1)
    }
    
    func testFormatterMatchesJSON_descriptor() {
        assertSnapshot(matching: task.metrics.metrics[0].descriptor, as: .json)
    }
}

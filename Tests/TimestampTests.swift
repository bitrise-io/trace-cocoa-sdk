//
//  TimestampTests.swift
//  Tests
//
//  Created by Shams Ahmed on 13/08/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

import XCTest
@testable import Trace

final class TimestampTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testTimestamp_isZeroPointOne_false1() {
        let start = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let end = TraceModel.Span.Timestamp(seconds: 1597337596, nanos: 9508882)
        let result = end - start
        let isZeroPointOne = result <= 100
        
        XCTAssertEqual(result, 2147)
        XCTAssertFalse(isZeroPointOne)
    }
    
    func testTimestamp_isZeroPointOne_sameValue() {
        let start = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let end = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let result = end - start
        let isZeroPointOne = result >= 100
        
        XCTAssertEqual(result, 0)
        XCTAssertFalse(isZeroPointOne)
    }
    
    func testTimestamp_isZeroPointOne_true1() {
        let start = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let end = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 6205882)
        let result = end - start
        let isZeroPointOne = result <= 100
        
        XCTAssertEqual(result, 88)
        XCTAssertTrue(isZeroPointOne)
    }
    
    func testTimestamp_isZeroPointOne_true2() {
        let start = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let end = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 5705882)
        let result = end - start
        let isZeroPointOne = result <= 100
        
        XCTAssertEqual(result, 38)
        XCTAssertTrue(isZeroPointOne)
    }
    
    func testTimestamp_isZeroPointOne_true3() {
        let start = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let end = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let result = end - start
        let isZeroPointOne = result <= 100
        
        XCTAssertEqual(result, 0)
        XCTAssertTrue(isZeroPointOne)
    }
    
    func testTimestamp_isZeroPointOne_negitiveEnd() {
        let start = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let end = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 232251)
        let result = end - start
        let isZeroPointOne = result >= 100
        
        XCTAssertEqual(result, -300)
        XCTAssertFalse(isZeroPointOne)
    }
    
    func testAddingMilliseconds_50() {
        let start = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let result = start + 50
        
        let startDate = Date.date(from: start)
        let updatedDate = Date.date(
            from: Time.Timestamp(seconds: result.seconds, nanos: result.nanos, timeInterval: 0)
        )
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.seconds, 1597337539)
        XCTAssertEqual(result.nanos, 582250834)
        
        XCTAssertNotNil(startDate)
        XCTAssertNotNil(updatedDate)
        XCTAssertEqual(startDate.description, updatedDate.description)
    }
    
    func testAddingMilliseconds_add_one_second() {
        let start = TraceModel.Span.Timestamp(seconds: 1597337539, nanos: 532251)
        let result = start + 500000000
        
        let startDate = Date.date(from: start)
        let updatedDate = Date.date(
            from: Time.Timestamp(seconds: result.seconds, nanos: result.nanos, timeInterval: 0)
        )
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.seconds, 1597337540)
        XCTAssertEqual(result.nanos, 914486885)
        
        XCTAssertNotNil(startDate)
        XCTAssertNotNil(updatedDate)
        XCTAssertEqual(startDate.description, "2020-08-13 16:52:19 +0000")
        XCTAssertEqual(updatedDate.description, "2020-08-13 16:52:20 +0000")
    }
    
    func testAddingMilliseconds_add_one_second_next_day() {
        let start = TraceModel.Span.Timestamp(seconds: 1597449599, nanos: 999251)
        let result = start + 100
        
        let startDate = Date.date(from: start)
        let updatedDate = Date.date(
            from: Time.Timestamp(seconds: result.seconds, nanos: result.nanos, timeInterval: 0)
        )
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.seconds, 1597449600)
        XCTAssertEqual(result.nanos, 99250793)
        
        XCTAssertNotNil(startDate)
        XCTAssertNotNil(updatedDate)
        XCTAssertEqual(startDate.description, "2020-08-14 23:59:59 +0000")
        XCTAssertEqual(updatedDate.description, "2020-08-15 00:00:00 +0000")
    }
    
}

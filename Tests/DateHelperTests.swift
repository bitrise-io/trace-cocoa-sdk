//
//  DateHelperTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/08/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class DateTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testTimestamp_date1() {
        let date = Date.date(from: TraceModel.Span.Timestamp(seconds: 1593681810, nanos: 396628))
        
        XCTAssertNotNil(date)
        XCTAssertNotEqual(date, Date())
    }
    
    func testTimestamp_string1() {
        let date = Date.date(from: TraceModel.Span.Timestamp(seconds: 1593681810, nanos: 396628))
        
        XCTAssertNotNil(date)
        XCTAssertNotEqual(date, Date())
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_GB")
        formatter.timeZone = TimeZone(identifier: "GMT")
        
        let stringDate = formatter.string(from: date)
        
        XCTAssertNotNil(stringDate)
        
        XCTAssertEqual(stringDate, "02/07/2020, 09:23")
    }
    
    func testTimestamp_date2() {
        let date = Date.date(from: TraceModel.Span.Timestamp(seconds: 1593681810, nanos: 396628))
        
        XCTAssertNotNil(date)
        XCTAssertNotEqual(date, Date())
    }
    
    func testTimestamp_string2() {
        let date = Date.date(from: TraceModel.Span.Timestamp(seconds: 1596461397, nanos: 123423))
        
        XCTAssertNotNil(date)
        XCTAssertNotEqual(date, Date())
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateStyle = .none
        formatter.timeStyle = .full
        formatter.locale = Locale(identifier: "en_GB")
        formatter.timeZone = TimeZone(identifier: "GMT")
        
        let stringDate = formatter.string(from: date)
        
        XCTAssertNotNil(stringDate)
        
        XCTAssertEqual(stringDate, "13:29:57 Greenwich Mean Time")
    }
}

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
        
        let stringDate = formatter.string(from: date)
        
        XCTAssertNotNil(stringDate)
        
        if TimeZone.current.isDaylightSavingTime(for: date) {
            XCTAssertEqual(stringDate, "7/2/20, 10:23 AM")
        } else {
            XCTAssertEqual(stringDate, "7/2/20, 09:23 AM")
        }
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
        
        let stringDate = formatter.string(from: date)
        
        XCTAssertNotNil(stringDate)
        
        if TimeZone.current.isDaylightSavingTime(for: date) {
            XCTAssertEqual(stringDate, "14:29:57 British Summer Time")
        } else {
            XCTAssertEqual(stringDate, "13:29:57 British Summer Time")
        }
    }
}

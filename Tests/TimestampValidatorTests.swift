//
//  TimestampValidatorTests.swift
//  Tests
//
//  Created by Shams Ahmed on 17/07/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class TimestampValidatorTests: XCTestCase {
    
    // MARK: - Property
    
    let date: Date! = {
        let isoDate = "2020-07-17T18:44:00+0000"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        
        return date
    }()
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testTimestamp1() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002132, nanos: 674656)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp2() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002133, nanos: 223654)
        
        XCTAssertTrue(result)
    }
    
    
    func testTimestamp3() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002108, nanos: 291347)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp4() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002103, nanos: 222419)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp5() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002059, nanos: 540069)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp6() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002060, nanos: 6335258)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp7() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002060, nanos: 40312)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp8() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002058, nanos: 630856)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp9() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002059, nanos: 542365)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp10() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1595002060, nanos: 13476)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp_fails1() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 1195002060, nanos: 6335258)
        
        XCTAssertFalse(result)
    }
    
    func testTimestamp_fails2() {
        let result = TimestampValidator(toDate: date).isValid(seconds: 0, nanos: 0)
        
        XCTAssertFalse(result)
    }
    
    func testTimestamp_object1() {
        let timestamp = Time.Timestamp(seconds: 1595002059, nanos: 542365, timeInterval: 0)
        let result = TimestampValidator(toDate: date).isValid(timestamp: timestamp)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp_object2() {
        let timestamp = Time.Timestamp(seconds: 1595002059, nanos: 442365, timeInterval: 0)
        let result = TimestampValidator(toDate: date).isValid(timestamp: timestamp)
        
        XCTAssertTrue(result)
    }
    
    func testTimestamp_object3() {
        let timestamp = Time.Timestamp(seconds: 1595002059, nanos: 365, timeInterval: 0)
        let result = TimestampValidator(toDate: date).isValid(timestamp: timestamp)
        
        XCTAssertTrue(result)
    }
    
    func testNanosecond_passes_greaterThan() {
        let validator = NanosecondValidator(
            start: Time.Timestamp(seconds: 1595002132, nanos: 674656, timeInterval: 0),
            end: Time.Timestamp(seconds: 1595012132, nanos: 1000, timeInterval: 0)
        )
        let result = validator.isGreaterThanOrEqual(1000)
        
        XCTAssertTrue(result)
    }
    
    func testNanosecond_passes_greaterThan_100() {
        let validator = NanosecondValidator(
            start: Time.Timestamp(seconds: 1595002132, nanos: 674650, timeInterval: 0),
            end: Time.Timestamp(seconds: 1595002132, nanos: 674701, timeInterval: 0)
        )
        let result = validator.isGreaterThanOrEqual(1000)
        
        XCTAssertFalse(result)
    }
    
    func testNanosecond_passes_greaterThan_1000() {
        let validator = NanosecondValidator(
            start: Time.Timestamp(seconds: 1595002132, nanos: 674650, timeInterval: 0),
            end: Time.Timestamp(seconds: 1595002132, nanos: 675650, timeInterval: 0)
        )
        let result = validator.isGreaterThanOrEqual(1000)
        
        XCTAssertFalse(result)
    }
    
    func testNanosecond_passes_greaterThan_10000() {
        let validator = NanosecondValidator(
            start: Time.Timestamp(seconds: 1595002132, nanos: 674650, timeInterval: 0),
            end: Time.Timestamp(seconds: 1595002132, nanos: 684650, timeInterval: 0)
        )
        let result = validator.isGreaterThanOrEqual(1000)
        
        XCTAssertFalse(result)
    }
    
    func testNanosecond_passes_equal() {
        let validator = NanosecondValidator(
            start: Time.Timestamp(seconds: 1595002132, nanos: 674656, timeInterval: 0),
            end: Time.Timestamp(seconds: 1595002132, nanos: 674656, timeInterval: 0)
        )
        let result = validator.isGreaterThanOrEqual(5000)
        
        XCTAssertFalse(result)
    }
    
    func testNanosecond_passes_lessThan() {
        let validator = NanosecondValidator(
            start: Time.Timestamp(seconds: 1595222132, nanos: 674656, timeInterval: 0),
            end: Time.Timestamp(seconds: 1595002132, nanos: 674696, timeInterval: 0)
        )
        let result = validator.isGreaterThanOrEqual(1000)
        
        XCTAssertFalse(result)
    }
    
    func testNanosecond_fails_noEnd() {
        let validator = NanosecondValidator(
            start: Time.Timestamp(seconds: 1595002132, nanos: 674656, timeInterval: 0),
            end: nil
        )
        let result = validator.isGreaterThanOrEqual(1000)
        
        XCTAssertFalse(result)
    }
    
    
    
    // isValid(seconds: 1595002108, nanos: 291347)
    // seconds: 1595002058, nanos: 630856)
    // 1595002059, nanos: 542365, timeInterval: 0)
}

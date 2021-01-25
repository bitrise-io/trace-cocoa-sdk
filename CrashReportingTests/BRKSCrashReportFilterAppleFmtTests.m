//
//  BRKSCrashReportFilterAppleFmtTests.m
//  CrashReportingTests
//
//  Created by Shams Ahmed on 25/01/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KSCrashReportFilterAppleFmt.h"

@interface BRKSCrashReportFilterAppleFmtTests : XCTestCase

@end

@implementation BRKSCrashReportFilterAppleFmtTests

- (void)setUp {

}

- (void)tearDown {

}

- (void)testClass {
    KSCrashReportFilterAppleFmt *report = [[KSCrashReportFilterAppleFmt alloc] init];
    
    XCTAssertNotNil(report);
}

- (void)testDateFormat1970 {
    KSCrashReportFilterAppleFmt *report = [[KSCrashReportFilterAppleFmt alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *string = [report stringFromDate: date];
    
    XCTAssertNotNil(string);
    XCTAssertFalse([string containsString:@"T"]);
    XCTAssertTrue([string isEqualToString:@"1970-01-01 00:00:00+00:00"]);
}

- (void)testDateFormatCustom {
    KSCrashReportFilterAppleFmt *report = [[KSCrashReportFilterAppleFmt alloc] init];
    NSDate *date = [NSDate date];
    NSString *string = [report stringFromDate: date];
    
    XCTAssertNotNil(string);
    XCTAssertFalse([string containsString:@"T"]);
    XCTAssertFalse([string containsString:@" "]);
}

@end

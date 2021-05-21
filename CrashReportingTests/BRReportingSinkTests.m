//
//  BRReportingSinkTests.m
//  CrashReportingTests
//
//  Created by Shams Ahmed on 19/05/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BRReportingSink.h"
#import "BRFilterPipeline.h"

@class BRReportingSink;
@class BRFilterPipeline;

@interface BRReportingSinkTests : XCTestCase

@end

@implementation BRReportingSinkTests

- (void)setUp {
    
}

- (void)tearDown {
    
}

- (void)testInit {
    BRReportingSink *sink1 = [[BRReportingSink alloc] init];
    BRReportingSink *sink2 = [[BRReportingSink alloc] initWithFileName:@"test"];
    
    XCTAssertNotNil(sink1);
    XCTAssertNotNil(sink2);
}

- (void)testFilter {
    BRReportingSink *sink = [[BRReportingSink alloc] initWithFileName:@"test"];
    BRFilterPipeline *filter = sink.filter;
    
    XCTAssertEqual(filter.filters.count, 3);
    XCTAssertEqual(sink.fileName, @"test");
}

- (void)testSave {
    BRReportingSink *sink = [[BRReportingSink alloc] initWithFileName:@"test"];
    
    NSString *path = NSTemporaryDirectory();
    path = [path stringByAppendingPathComponent:@"test"];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
    
    BOOL result = [sink saveReport: [NSData data] atPath:url];
    
    XCTAssertTrue(result);
}

- (void)testFilterReport_empty {
    NSArray *reports = @[];
    __block BOOL completed;
    __block NSError* error;
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test"];
    
    BRReportingSink *sink = [[BRReportingSink alloc] initWithFileName:@"test"];
    [sink filterReports:reports onCompletion: ^(NSArray* filteredReports, BOOL result, NSError* reportError) {
        completed = result;
        error = reportError;
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:5];
    
    XCTAssertTrue(completed);
    XCTAssertNil(error);
}

- (void)testFilterReport_one {
    NSURL *url = [[NSBundle bundleForClass: self.class] URLForResource:@"iOSDemo-report-0074043ca8000000" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL: url];
    
    NSArray *reports = @[data];
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test"];
    __block BOOL completed;
    __block NSError* error;
    __block NSArray* filteredReports;
    
    BRReportingSink *sink = [[BRReportingSink alloc] initWithFileName:@"test"];
    [sink filterReports:reports onCompletion: ^(NSArray* reports, BOOL result, NSError* reportError) {
        completed = result;
        error = reportError;
        filteredReports = reports;
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:5];
    
    XCTAssertTrue(completed);
    XCTAssertNil(error);
    XCTAssertEqual(filteredReports.count, 1);
}

- (void)testFilterReport_many {
    NSBundle *bundle = [NSBundle bundleForClass: self.class];
    NSURL *url1 = [bundle URLForResource:@"iOSDemo-report-0074043ca8000000" withExtension:@"json"];
    NSURL *url2 = [bundle URLForResource:@"iOSDemo-report-0074043d2e000000" withExtension:@"json"];
    NSURL *url3 = [bundle URLForResource:@"iOSDemo-report-0074044008000000" withExtension:@"json"];
    NSData *data1 = [NSData dataWithContentsOfURL: url1];
    NSData *data2 = [NSData dataWithContentsOfURL: url2];
    NSData *data3 = [NSData dataWithContentsOfURL: url3];
    NSArray *reports = @[data1, data2, data3];
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test"];
    __block BOOL completed;
    __block NSError* error;
    __block NSArray* filteredReports;
    
    BRReportingSink *sink = [[BRReportingSink alloc] initWithFileName:@"test"];
    [sink filterReports:reports onCompletion: ^(NSArray* reports, BOOL result, NSError* reportError) {
        completed = result;
        error = reportError;
        filteredReports = reports;
        
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:5];
    
    XCTAssertTrue(completed);
    XCTAssertNil(error);
    XCTAssertEqual(filteredReports.count, 3);
}

@end

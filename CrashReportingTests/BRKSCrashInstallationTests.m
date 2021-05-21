//
//  BRKSCrashInstallationTests.m
//  CrashReportingTests
//
//  Created by Shams Ahmed on 07/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KSCrashInstallation.h"
#import "BRReportingSink.h"
#import "KSCrashReportWriter.h"

@class KSCrashInstallation;
@class BRReportingSink;

@interface BRKSCrashInstallationTests : XCTestCase

@end

@implementation BRKSCrashInstallationTests

#pragma mark - Setup

- (void)setUp {
   
}

- (void)tearDown {
   
}

#pragma mark - Tests

- (void)testInstallation {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    
    XCTAssertNotNil(installation);
    XCTAssertNotNil(installation.userInfo);
    XCTAssertNotNil(installation.description);
}

- (void)testInstallation_userInfo {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    
    XCTAssertNotNil(installation.userInfo);
    XCTAssertTrue(installation.userInfo.count == 0);
    
    installation.userInfo = @{@"test1" : @"test1", @"test2" : @"test2"};
    
    XCTAssertNotNil(installation.userInfo);
    XCTAssertTrue(installation.userInfo.count == 2);
}

- (void)testInstallation_reports {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    NSUInteger reportCount = installation.reportCount;
    NSArray *reports = installation.allReport;
    
    XCTAssertTrue(reportCount == 0);
    XCTAssertNotNil(reports);
    XCTAssertTrue(reports.count == 0);
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        
    }];
}

- (void)testSink {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    BRReportingSink *sink = installation.sink;
    
    XCTAssertNotNil(sink);
}

- (void)testDeleteAllReports {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    [installation deleteAllReports];
    
    XCTAssertEqual(installation.reportCount, 0);
}

- (void)testAllReport {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    NSArray *reports = installation.allReport;
    
    XCTAssertEqual(reports.count, 0);
}

- (void)testAllReportsWithCompletion {
    __block BOOL isCompleted;
    __block NSError *error;
    
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    [installation allReportsWithCompletion: ^(NSArray* filteredReports, BOOL completed, NSError* newError) {
        completed = isCompleted;
        error = newError;
    }];
    
    XCTAssertFalse(isCompleted);
    XCTAssertNil(error);
}

- (void)testIsEnabled {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    BOOL isEnabled = installation.isEnabled;
    
    XCTAssertFalse(isEnabled);
}

- (void)testInstall {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    BOOL installed = [installation install];
    
    XCTAssertNotNil(installation.userInfo);
    XCTAssertEqual(installation.userInfo.count, 0);
    XCTAssertTrue(installed);
    XCTAssertTrue(installation.isEnabled);
}

static void crashCallback(const KSCrashReportWriter* writer) {
    // You can add extra user data at crash time if you want.
    writer->addBooleanElement(writer, "some_bool_value", NO);
    NSLog(@"***advanced_crash_callback");
}

- (void)testOnCrash {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    installation.onCrash = crashCallback;
    
    XCTAssertTrue(installation.onCrash != NULL);
}

@end

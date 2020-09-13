//
//  BRKSCrashInstallationTests.m
//  CrashReportingTests
//
//  Created by Shams Ahmed on 07/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KSCrashInstallation.h"

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
    XCTAssertNil(installation.userInfo);
    XCTAssertNotNil(installation.description);
}

- (void)testInstallation_userInfo {
    KSCrashInstallation *installation = [[KSCrashInstallation alloc] init];
    
    XCTAssertNil(installation.userInfo);
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

@end

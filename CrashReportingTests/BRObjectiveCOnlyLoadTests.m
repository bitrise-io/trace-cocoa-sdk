//
//  BRObjectiveCOnlyLoadTests.m
//  CrashReportingTests
//
//  Created by Shams Ahmed on 09/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
//#import <TraceInternal/TraceInternal.h>

@interface BRObjectiveCOnlyLoadTests : XCTestCase

@end

@implementation BRObjectiveCOnlyLoadTests

#pragma mark - Setup

- (void)setUp {
    
}

- (void)tearDown {
    
}

#pragma mark - Tests

- (void)testInclude {
    Class class = NSClassFromString(@"BRInternalObjectiveCOnlyLoadUsingClassMethod");
    
    XCTAssertNotNil(class);
}

@end

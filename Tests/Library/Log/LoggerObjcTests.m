//
//  LoggerObjcTests.m
//  Tests
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

#import <XCTest/XCTest.h>

#if __has_include(<Trace/Trace-Swift.h>)
#import <Trace/Trace-Swift.h> // Framework
#else
#import <Trace-Swift.h> // Static library
#endif

@interface LoggerObjcTests: XCTestCase

@end

@implementation LoggerObjcTests

# pragma mark - Setup

- (void)setUp {
    
}

- (void)tearDown {
    
}

# pragma mark - Tests

- (void)testLogger {
    Class logger = NSClassFromString(@"BRLoggerObjc");
    
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    BOOL result = [logger performSelector:@selector(print:for:)
                            withObject:@"test"
                            withObject:@"launch"
    ];
    #pragma clang diagnostic pop
    
    XCTAssertTrue(result);
}

- (void)testLogger_failsWithUnknown {
    Class logger = NSClassFromString(@"BRLoggerObjc");
    
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    BOOL result = [logger performSelector:@selector(print:for:)
                            withObject:@"test"
                            withObject:@"unknown"
    ];
    #pragma clang diagnostic pop
    
    XCTAssertFalse(result);
}

@end

//
//  SelectorTests.m
//  Tests
//
//  Created by Shams Ahmed on 09/04/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import <XCTest/XCTest.h>

#if __has_include(<Trace/Trace-Swift.h>)
#import <Trace/Trace-Swift.h> // Framework
#else
#import <Trace-Swift.h> // Static library
#endif

@interface SelectorTests : XCTestCase

@end

@implementation SelectorTests

# pragma mark - Setup

- (void)setUp {
 
}

- (void)tearDown {
 
}

# pragma mark - Tests

- (void)testReset {
    // check if method exist.
    // also test should not crash
    BOOL result1 = [BRTrace respondsToSelector:@selector(reset)];
    id result2 = [BRTrace performSelector:@selector(reset)];
    
    IMP signature = [BRTrace methodForSelector:@selector(reset)];
    NSMethodSignature *methodSignature = [BRTrace methodSignatureForSelector:@selector(reset)];
    
    [BRTrace performSelectorInBackground:@selector(reset) withObject:nil];
    [BRTrace performSelectorOnMainThread:@selector(reset) withObject:nil waitUntilDone:true];
    
    BOOL result3 = signature != NULL;
    
    // check if i can run still...
    int test = 1 + 1;
    
    XCTAssertTrue(result1);
    XCTAssertNil(result2);
    XCTAssertTrue(result3);
    
    XCTAssertNotNil(methodSignature);
    XCTAssertEqual(methodSignature.numberOfArguments, 2);
    
    XCTAssertEqual(test, 2);
}

- (void)testLogger_passes {
    Class logger = NSClassFromString(@"BRLoggerObjc");
    
    XCTAssertNotNil(logger);
    
    BOOL result = [logger performSelector:@selector(print:for:)
                            withObject:@"test"
                            withObject:@"launch"
    ];
    
    // check if i can run still...
    int test = 1 + 1;
    
    XCTAssertTrue(result);
    XCTAssertEqual(test, 2);
}

- (void)testLogger_fails {
    Class logger = NSClassFromString(@"BRLoggerObjc");
    
    XCTAssertNotNil(logger);
    
    BOOL result = [logger performSelector:@selector(print:for:)
                            withObject:@"test"
                            withObject:@"fail"
    ];
    
    // check if i can run still...
    int test = 1 + 1;
    
    XCTAssertFalse(result);
    XCTAssertEqual(test, 2);
}

@end

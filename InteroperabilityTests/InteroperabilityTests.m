//
//  InteroperabilityTests.m
//  Interoperability
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

#import <XCTest/XCTest.h>

#if __has_include(<Trace/Trace-Swift.h>)
#import <Trace/Trace-Swift.h> // Framework
#else
#import <Trace-Swift.h> // Static library
#endif

// Interoperability purpose is to test all public methods and propertises exposed in Objective-C to make sure it does not break and doesn't get created because it only for Swift.
@interface InteroperabilityTests : XCTestCase

@end

@implementation InteroperabilityTests

# pragma mark - Setup

- (void)setUp {
 
}

- (void)tearDown {
 
}

# pragma mark - Tests

- (void)testShared {
    // Trace
    BRTrace *trace = [BRTrace shared];
    
    XCTAssertNotNil(trace);
}

- (void)testConfiguration {
    // Trace
    BRConfiguration *configuration = [BRTrace configuration];
    BRConfiguration *configuration2 = [BRConfiguration default];
    
    BRTrace.configuration = configuration2;
    
    XCTAssertNotNil(configuration);
    XCTAssertNotNil(configuration2);
    XCTAssertEqual(configuration.logs, configuration2.logs);
}

- (void)testAttributes {
    // Attributes
    NSDictionary<NSString *, NSString *> *attributes = @{@"attribute1": @"attributesValue"};
    
    // Trace
    BRTrace *trace = [BRTrace shared];
    trace.attributes = attributes;
    
    BOOL result = [trace.attributes isEqualToDictionary:attributes];
    
    XCTAssertNotNil(trace.attributes);
    XCTAssertTrue(result);
}

@end

//
//  Container+DeepSearch_Tests.m
//
//  Created by Karl Stenerud on 2012-08-26.
//
//  Copyright (c) 2012 Karl Stenerud. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall remain in place
// in this source code.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import <XCTest/XCTest.h>

#import "Container+DeepSearch.h"
#import "NSError+SimpleConstructor.h"

@interface Container_DeepSearch_Tests : XCTestCase @end

@implementation Container_DeepSearch_Tests

- (void) testDeepSearchDictionary
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      expected, @"key3",
                      nil], @"key2",
                     nil], @"key1",
                    nil];

    id deepKey = [NSArray arrayWithObjects:@"key1", @"key2", @"key3", nil];
    id actual = [container bitrise_objectForDeepKey:deepKey];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testDeepSearchDictionaryPath
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      expected, @"key3",
                      nil], @"key2",
                     nil], @"key1",
                    nil];

    id actual = [container bitrise_objectForKeyPath:@"key1/key2/key3"];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testDeepSearchDictionaryPathAbs
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      expected, @"key3",
                      nil], @"key2",
                     nil], @"key1",
                    nil];
    
    id actual = [container bitrise_objectForKeyPath:@"/key1/key2/key3"];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testDeepSearchDictionary2
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      expected, @"3",
                      nil], @"2",
                     nil], @"1",
                    nil];

    id deepKey = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    id actual = [container bitrise_objectForDeepKey:deepKey];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testDeepSearchDictionary2Path
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      expected, @"3",
                      nil], @"2",
                     nil], @"1",
                    nil];

    id actual = [container bitrise_objectForKeyPath:@"1/2/3"];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testDeepSearchMixed
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSArray arrayWithObjects:
                     @"blah",
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      expected, @"key3",
                      nil],
                     nil], @"key1",
                    nil];

    id deepKey = [NSArray arrayWithObjects:
                        @"key1",
                        [NSNumber numberWithInt:1],
                        @"key3", nil];
    id actual = [container bitrise_objectForDeepKey:deepKey];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testDeepSearchMixedPath
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSArray arrayWithObjects:
                     @"blah",
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      expected, @"key3",
                      nil],
                     nil], @"key1",
                    nil];

    id actual = [container bitrise_objectForKeyPath:@"key1/1/key3"];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testDeepSearchNotFound
{
    id container = [NSDictionary dictionary];
    id deepKey = [NSArray arrayWithObjects:@"key1", nil];
    id actual = [container bitrise_objectForDeepKey:deepKey];
    XCTAssertNil(actual, @"");
}

- (void) testDeepSearchNonContainerObject
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSArray arrayWithObjects:
                     @"blah",
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      expected, @"key3",
                      nil],
                     nil], @"key1",
                    nil];

    id deepKey = [NSArray arrayWithObjects:
                        @"key1",
                        [NSNumber numberWithInt:1],
                        @"key3",
                        @"key4", nil];
    id actual = [container bitrise_objectForDeepKey:deepKey];
    XCTAssertNil(actual, @"");
}

- (void) testSetObjectForDeepKeyDict
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"someObject", @"someKey",
                      nil], @"key2",
                     nil], @"key1",
                    nil];
    
    id deepKey = [NSArray arrayWithObjects:@"key1", @"key2", @"key3", nil];
    [container bitrise_setObject:expected forDeepKey:deepKey];
    id actual = [container bitrise_objectForDeepKey:deepKey];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testSetObjectForDeepKeyDictSimple
{
    id expected = @"Object";
    id container = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"someObject", @"someKey",
                    nil];
    
    id deepKey = [NSArray arrayWithObjects:@"key1", nil];
    [container bitrise_setObject:expected forDeepKey:deepKey];
    id actual = [container bitrise_objectForDeepKey:deepKey];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testSetObjectForDeepKeyDictEmptyKey
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"someObject", @"someKey",
                      nil], @"key2",
                     nil], @"key1",
                    nil];
    
    id deepKey = [NSArray array];
    XCTAssertThrows([container bitrise_setObject:expected forDeepKey:deepKey], @"");
}

- (void) testSetObjectForDeepKeyInvalidContainer
{
    id expected = @"Object";
    id container = [NSDate date];
    
    id deepKey = [NSArray arrayWithObjects:@"key1", @"key2", @"0", nil];
    XCTAssertThrows([container bitrise_setObject:expected forDeepKey:deepKey], @"");
}

- (void) testSetObjectForDeepKeyImmutableArray
{
    id expected = @"Object";
    id container = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSArray arrayWithObjects:
                      @"someObject",
                      nil], @"key2",
                     nil],
                    nil];
    
    id deepKey = [NSArray arrayWithObjects:@"0", @"key2", @"0", nil];
    XCTAssertThrows([container bitrise_setObject:expected forDeepKey:deepKey], @"");
}

- (void) testSetObjectForDeepKeyImmutableDict
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      @"someObject", @"someKey",
                      nil], @"key2",
                     nil], @"key1",
                    nil];
    
    id deepKey = [NSArray arrayWithObjects:@"key1", @"key2", [NSDate date], nil];
    XCTAssertThrows([container bitrise_setObject:expected forDeepKey:deepKey], @"");
}

- (void) testSetObjectForKeyPathDict
{
    id expected = @"Object";
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"someObject", @"someKey",
                      nil], @"key2",
                     nil], @"key1",
                    nil];
    
    id deepKey = @"key1/key2/key3";
    [container bitrise_setObject:expected forKeyPath:deepKey];
    id actual = [container bitrise_objectForKeyPath:deepKey];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void) testRemoveObjectForDeepKeyDict
{
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"someObject", @"key3",
                      nil], @"key2",
                     nil], @"key1",
                    nil];
    
    id deepKey = [NSArray arrayWithObjects:@"key1", @"key2", @"key3", nil];
    [container bitrise_removeObjectForDeepKey:deepKey];
    id actual = [container bitrise_objectForDeepKey:deepKey];
    XCTAssertNil(actual, @"");
}

- (void) testRemoveObjectForKeyPathDict
{
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"someObject", @"key3",
                      nil], @"key2",
                     nil], @"key1",
                    nil];
    
    id deepKey = @"key1/key2/key3";
    [container bitrise_removeObjectForKeyPath:deepKey];
    id actual = [container bitrise_objectForKeyPath:deepKey];
    XCTAssertNil(actual, @"");
}

- (void) testRemoveObjectForDeepKeyInvalidContainer
{
    id container = [NSDate date];
    
    id deepKey = [NSArray arrayWithObjects:@"key1", @"key2", @"0", nil];
    XCTAssertThrows([container bitrise_removeObjectForDeepKey:deepKey], @"");
}

- (void) testRemoveObjectForDeepKeyImmutableArray
{
    id container = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSArray arrayWithObjects:
                      @"someObject",
                      nil], @"key2",
                     nil],
                    nil];
    
    id deepKey = [NSArray arrayWithObjects:@"0", @"key2", @"0", nil];
    XCTAssertThrows([container bitrise_removeObjectForDeepKey:deepKey], @"");
}

- (void) testRemoveObjectForDeepKeyImmutableDict
{
    id container = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      @"someObject", @"someKey",
                      nil], @"key2",
                     nil], @"key1",
                    nil];
    
    id deepKey = [NSArray arrayWithObjects:@"key1", @"key2", [NSDate date], nil];
    XCTAssertThrows([container bitrise_removeObjectForDeepKey:deepKey], @"");
}

@end

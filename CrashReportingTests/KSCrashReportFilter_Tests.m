//
//  KSCrashReportFilter_Tests.m
//
//  Created by Karl Stenerud on 2012-05-12.
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

#import "KSCrashReportFilter.h"
#import "NSError+SimpleConstructor.h"
#import "BRFilterStringToData.h"
#import "BRFilterPipeline.h"

#if __has_include(<TraceInternal/TraceInternal.h>)
#import <TraceInternal/TraceInternal.h> // Framework
#else
#import <TraceInternal.h> // Static library
#endif

@interface KSCrash_TestNilFilter: NSObject <KSCrashReportFilter>

@end

@implementation KSCrash_TestNilFilter

+ (KSCrash_TestNilFilter*) filter
{
    return [[self alloc] init];
}

- (void) filterReports:(__unused NSArray*) reports onCompletion:(KSCrashReportFilterCompletion) onCompletion
{
    onCompletion(nil, YES, nil);
}

@end


@interface KSCrash_TestFilter: NSObject <KSCrashReportFilter>

@property(nonatomic,readwrite,assign) NSTimeInterval delay;
@property(nonatomic,readwrite,assign) BOOL completed;
@property(nonatomic,readwrite,retain) NSError* error;
@property(nonatomic,readwrite,retain) NSTimer* timer;
@property(nonatomic,readwrite,retain) NSArray* reports;
@property(nonatomic,readwrite,copy) KSCrashReportFilterCompletion onCompletion;

@end

@implementation KSCrash_TestFilter

@synthesize delay = _delay;
@synthesize completed = _completed;
@synthesize error = _error;
@synthesize reports = _reports;
@synthesize timer = _timer;
@synthesize onCompletion = _onCompletion;

+ (KSCrash_TestFilter*) filterWithDelay:(NSTimeInterval) delay
                              completed:(BOOL) completed
                                  error:(NSError*) error
{
    return [[self alloc] initWithDelay:delay completed:completed error:error];
}

- (id) initWithDelay:(NSTimeInterval) delay
           completed:(BOOL) completed
               error:(NSError*) error
{
    if((self = [super init]))
    {
        self.delay = delay;
        self.completed = completed;
        self.error = error;
    }
    return self;
}

- (void) filterReports:(NSArray*) reports
          onCompletion:(KSCrashReportFilterCompletion) onCompletion
{
    self.reports = reports;
    self.onCompletion = onCompletion;
    if(self.delay > 0)
    {
        self.timer = [NSTimer timerWithTimeInterval:self.delay target:self selector:@selector(onTimeUp) userInfo:nil repeats:NO];
    }
    else
    {
        [self onTimeUp];
    }
}

- (void) onTimeUp
{
    kscrash_callCompletion(self.onCompletion, self.reports, self.completed, self.error);
}

@end


@interface KSCrashReportFilter_Tests : XCTestCase @end

@implementation KSCrashReportFilter_Tests

#if __has_feature(objc_arc)

- (void) testPipeline
{
    NSArray* expected = [NSArray arrayWithObjects:@"11232323", @"2", @"3", nil];
    NSArray* filters = @[[[BRFilterStringToData alloc] init]];
    
    id<KSCrashReportFilter> filter = [BRFilterPipeline filters:filters];
    
    [filter filterReports:expected onCompletion:^(NSArray* filteredReports,
                                                  BOOL completed,
                                                  NSError* error)
     {
         XCTAssertTrue(completed, @"");
         XCTAssertNil(error, @"");
         XCTAssertEqual(expected.count, filteredReports.count);
     }];
}

- (void) testPipelineInit
{
    NSArray* expected = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    NSArray* filters = @[[BRFilterStringToData new]];
    
    id<KSCrashReportFilter> filter = [BRFilterPipeline filters:filters];
    
    filter = filter;
    
    [filter filterReports:expected onCompletion:^(NSArray* filteredReports,
                                                  BOOL completed,
                                                  NSError* error)
     {
         XCTAssertTrue(completed, @"");
         XCTAssertNil(error, @"");
         XCTAssertEqual(expected.count, filteredReports.count);
     }];
}

- (void) testPipelineNoFilters
{
    NSArray* expected = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    NSArray* filters = @[];
    
    id<KSCrashReportFilter> filter = [BRFilterPipeline filters:filters];
    
    [filter filterReports:expected onCompletion:^(NSArray* filteredReports,
                                                  BOOL completed,
                                                  NSError* error)
     {
         XCTAssertTrue(completed, @"");
         XCTAssertNil(error, @"");
         XCTAssertEqualObjects(expected, filteredReports, @"");
     }];
}

- (void) testFilterPipelineIncomplete
{
    NSArray* expected1 = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    NSArray* filters = @[[KSCrash_TestFilter filterWithDelay:0 completed:NO error:nil]];
    
    id<KSCrashReportFilter> filter = [BRFilterPipeline filters:filters];
    
    [filter filterReports:expected1 onCompletion:^(NSArray* filteredReports,
                                                   BOOL completed,
                                                   NSError* error)
     {
         XCTAssertNotNil(filteredReports, @"");
         XCTAssertFalse(completed, @"");
         XCTAssertNil(error, @"");
     }];
}

- (void) testFilterPipelineNilReports
{
    NSArray* expected1 = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    NSArray* filters = @[[KSCrash_TestNilFilter filter]];
    
    id<KSCrashReportFilter> filter = [BRFilterPipeline filters:filters];
    
    [filter filterReports:expected1 onCompletion:^(NSArray* filteredReports,
                                                   BOOL completed,
                                                   NSError* error)
     {
         XCTAssertNil(filteredReports, @"");
         XCTAssertFalse(completed, @"");
         XCTAssertNotNil(error, @"");
     }];
}

- (void) testPiplelineLeak1
{
    __block NSArray* reports = [NSArray arrayWithObjects:@"one", @"two", nil];
    __block id<KSCrashReportFilter> filter = [KSCrash_TestFilter filterWithDelay:0.1 completed:YES error:nil];

    __weak id weakReports = reports;
    __weak id weakFilter = filter;
    
    __block BRFilterPipeline* pipeline = [BRFilterPipeline filters:@[filter]];
    [pipeline filterReports:reports
               onCompletion:^(__unused NSArray* filteredReports,
                              __unused BOOL completed,
                              __unused NSError* error)
     {
         reports = nil;
         filter = nil;
         pipeline = nil;
         XCTAssertTrue(completed, @"");
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            XCTAssertNil(weakReports, @"Object leaked");
                            XCTAssertNil(weakFilter, @"Object leaked");
                        });
     }];
}

- (void) testPiplelineLeak2
{
    __block NSArray* reports = [NSArray arrayWithObjects:@"one", @"two", nil];
    __block id<KSCrashReportFilter> filter = [KSCrash_TestFilter filterWithDelay:0.1 completed:NO error:nil];

    __weak id weakReports = reports;
    __weak id weakFilter = filter;

    __block BRFilterPipeline* pipeline = [BRFilterPipeline filters:@[filter]];
    [pipeline filterReports:reports
               onCompletion:^(__unused NSArray* filteredReports,
                              __unused BOOL completed,
                              __unused NSError* error)
     {
         reports = nil;
         filter = nil;
         pipeline = nil;
         XCTAssertFalse(completed, @"");
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            XCTAssertNil(weakReports, @"Object leaked");
                            XCTAssertNil(weakFilter, @"Object leaked");
                        });
     }];
}

#endif


- (void) testFilterStringToData
{
    NSArray* source = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    NSArray* expected = [NSArray arrayWithObjects:
                         (id _Nonnull)[@"1" dataUsingEncoding:NSUTF8StringEncoding],
                         (id _Nonnull)[@"2" dataUsingEncoding:NSUTF8StringEncoding],
                         (id _Nonnull)[@"3" dataUsingEncoding:NSUTF8StringEncoding],
                         nil];
    id<KSCrashReportFilter> filter = [BRFilterStringToData new];

    [filter filterReports:source onCompletion:^(NSArray* filteredReports,
                                                BOOL completed,
                                                NSError* error)
     {
         XCTAssertTrue(completed, @"");
         XCTAssertNil(error, @"");
         XCTAssertEqualObjects(expected, filteredReports, @"");
     }];
}

- (void) testFilterPipeline
{
    NSArray* expected = [NSArray arrayWithObjects:@"1", @"2", nil];
    NSArray* filters = @[[BRFilterStringToData new]];
    
    id<KSCrashReportFilter> filter = [BRFilterPipeline filters: filters];
    
    [filter filterReports:expected onCompletion:^(NSArray* filteredReports,
                                                  BOOL completed,
                                                  NSError* error)
     {
         XCTAssertTrue(completed, @"");
         XCTAssertNil(error, @"");
     }];
}

@end

//
//  BRFilterPipeline.m
//  TraceInternal
//
//  Created by Shams Ahmed on 03/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import "BRFilterPipeline.h"
#import "NSError+SimpleConstructor.h"

@implementation BRFilterPipeline

@synthesize filters = _filters;

#pragma mark - Static

/// Batch X number of filters and process the final result
+ (BRFilterPipeline *)filters:(NSArray *)filters {
    BRFilterPipeline *pipeline = [[BRFilterPipeline alloc] init];
    pipeline.filters = filters;

    return pipeline;
}

#pragma mark - Filter

- (void)filterReports:(NSArray *)reports onCompletion:(KSCrashReportFilterCompletion)onCompletion {
    NSArray* filters = self.filters;
    NSUInteger filterCount = filters.count;
    
    if (filterCount == 0) {
        kscrash_callCompletion(onCompletion, reports, YES,  nil);
        return;
    }
    
    __block NSUInteger iFilter = 0;
    __block KSCrashReportFilterCompletion filterCompletion;
    __block __weak KSCrashReportFilterCompletion weakFilterCompletion = nil;
    dispatch_block_t disposeOfCompletion = [^
                                            {
                                                // Release self-reference on the main thread.
                                                dispatch_async(dispatch_get_main_queue(), ^
                                                               {
                                                                   filterCompletion = nil;
                                                               });
                                            } copy];
    
    filterCompletion = [^(NSArray* filteredReports,
                          BOOL completed,
                          NSError* filterError)
                        {
                            if(!completed || filteredReports == nil)
                            {
                                if(!completed)
                                {
                                    kscrash_callCompletion(onCompletion,
                                                             filteredReports,
                                                             completed,
                                                             filterError);
                                }
                                else if(filteredReports == nil)
                                {
                                    kscrash_callCompletion(onCompletion, filteredReports, NO,
                                                             [NSError bitrise_errorWithDomain:[[self class] description]
                                                                                 code:0
                                                                          description:@"filteredReports was nil"]);
                                }
                                disposeOfCompletion();
                                return;
                            }
                            
                            // Normal run until all filters exhausted or one
                            // filter fails to complete.
                            if(++iFilter < filterCount)
                            {
                                id<KSCrashReportFilter> filter = [filters objectAtIndex:iFilter];
                                [filter filterReports:filteredReports onCompletion:weakFilterCompletion];
                                return;
                            }
                            
                            // All filters complete, or a filter failed.
                            kscrash_callCompletion(onCompletion, filteredReports, completed, filterError);
                            disposeOfCompletion();
                        } copy];
    weakFilterCompletion = filterCompletion;
    
    // Initial call with first filter to start everything going.
    id<KSCrashReportFilter> filter = [filters objectAtIndex:iFilter];
    [filter filterReports:reports onCompletion:filterCompletion];
}

@end

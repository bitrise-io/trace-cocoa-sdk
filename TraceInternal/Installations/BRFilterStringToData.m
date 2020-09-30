//
//  BRFilterStringToData.m
//  TraceInternal
//
//  Created by Shams Ahmed on 03/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import "BRFilterStringToData.h"
#import "BRLogger.h"

@implementation BRFilterStringToData

#pragma mark - Filter

- (void)filterReports:(NSArray *)reports onCompletion:(KSCrashReportFilterCompletion)onCompletion {
    NSMutableArray* filteredReports = [NSMutableArray arrayWithCapacity:reports.count];

    for (NSString* report in reports)
    {
        NSData* converted = [report dataUsingEncoding:NSUTF8StringEncoding];

        if(converted == nil)
        {
            [BRLogger print:@"Could not convert report to UTF-8" forModule:BRLoggerModuleCrash];
        }
        else
        {
            [filteredReports addObject:converted];
        }
    }

    kscrash_callCompletion(onCompletion, filteredReports, YES, nil);
}

@end

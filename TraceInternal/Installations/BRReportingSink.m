//
//  BRReportingSink.m
//  TraceInternal
//
//  Created by Shams Ahmed on 03/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import "BRReportingSink.h"
#import "BRFilterPipeline.h"
#import "KSCrashReportFilterAppleFmt.h"
#import "BRLogger.h"
#import "BRFilterStringToData.h"

@implementation BRReportingSink

#pragma mark - Init

- (instancetype)initWithFileName:(NSString* )fileName {
    if (self = [super init]) {
        self.fileName = fileName;
        self.filter = [BRFilterPipeline filters: @[
            [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicated],
            [[BRFilterStringToData alloc] init],
            self
        ]];
    }
    
    return self;
}

#pragma mark - Filter

/// Convert json crash report into Apple style format and save to disk
- (void)filterReports:(NSArray<NSData *> *)reports onCompletion:(KSCrashReportFilterCompletion)onCompletion {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, TRUE).firstObject;
    path = [path stringByAppendingPathComponent:@"Bitrise"];
    path = [path stringByAppendingPathComponent:@"Crashes"];
    path = [path stringByAppendingPathComponent:@"Formatted"];
    
    [reports enumerateObjectsUsingBlock:^(NSData * _Nonnull report, NSUInteger offset, BOOL * _Nonnull stop) {
        NSString *name = [NSString stringWithFormat:self.fileName, offset + 1];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:name]];
        
        [self saveReport:report atPath:url];
    }];
    
    kscrash_callCompletion(onCompletion, reports, true, nil);
}

#pragma mark - Save

- (BOOL)saveReport:(NSData *)report atPath:(NSURL *)location {
    BOOL result = [report writeToURL:location atomically:true];
    
    if (!result) {
        [BRLogger print:@"Failed to write crash report to document directory" forModule:BRLoggerModuleInternalError];
    }
    
    return result;
}

@end

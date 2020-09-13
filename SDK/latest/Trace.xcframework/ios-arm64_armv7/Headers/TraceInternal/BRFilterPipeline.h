//
//  BRFilterPipeline.h
//  TraceInternal
//
//  Created by Shams Ahmed on 03/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCrashReportFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRFilterPipeline : NSObject<KSCrashReportFilter>

/** The filters in this pipeline. */
@property(nonatomic, retain) NSArray* filters;

+ (BRFilterPipeline *)filters:(NSArray *)filters;
- (void)filterReports:(NSArray *)reports onCompletion:(KSCrashReportFilterCompletion)onCompletion;


@end

NS_ASSUME_NONNULL_END

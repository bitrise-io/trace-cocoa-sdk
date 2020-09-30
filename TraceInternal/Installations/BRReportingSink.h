//
//  BRReportingSink.h
//  TraceInternal
//
//  Created by Shams Ahmed on 03/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCrashReportFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRReportingSink : NSObject<KSCrashReportFilter>

@property (nonatomic) id filter;
@property (nonatomic) NSString* fileName;

- (instancetype)initWithFileName:(NSString* )fileName;

@end

NS_ASSUME_NONNULL_END

//
//  BRLogger.h
//  TraceInternal
//
//  Created by Shams Ahmed on 03/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BRLoggerModule) {
    BRLoggerModuleLaunch,
    BRLoggerModuleInternalError,
    BRLoggerModuleCrash
};

@interface BRLogger : NSObject

+ (void)print:(NSString *)message forModule:(BRLoggerModule)module;

@end

NS_ASSUME_NONNULL_END

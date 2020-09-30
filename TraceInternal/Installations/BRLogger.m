//
//  BRLogger.m
//  TraceInternal
//
//  Created by Shams Ahmed on 03/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import "BRLogger.h"
#import <Foundation/Foundation.h>

@implementation BRLogger: NSObject

#pragma mark - Print

+ (void)print:(NSString *)message forModule:(BRLoggerModule)module {
    NSString *name;
    
    switch (module) {
        case BRLoggerModuleLaunch:
            name = @"launch";
            
            break;
        case BRLoggerModuleInternalError:
            name = @"internalError";
            
            break;
        case BRLoggerModuleCrash:
            name = @"crash";
            
            break;
    }
    
    NSString *print = [NSString stringWithFormat:@"[Bitrise:Trace/%@] %@", name, message];
    
    NSLog(@"%@", print);
}

@end

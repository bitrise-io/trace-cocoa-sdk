//
//  ObjectiveCOnlyLoad.m
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<Trace/Trace-Swift.h>)
#import <Trace/Trace-Swift.h> // Framework
#else
#import <Trace-Swift.h> // Static library
#endif

#pragma mark - Constructor/Destructor

/// Second attempt at starting SDK
/// Using library constructor to start the SDK
/// By default when the SDK is moved to memory the SDK `constructor` method is called
__attribute__((constructor)) static void ObjectiveCOnlyLoad(void) {
    if (BRTrace.configuration.enabled == NO) {
        NSLog(@"[Bitrise:Trace/launch] SDK disabled");
        
        return;
    }
    
    // Update session timeout values only if the SDK hasn't been started yet
    if (BRTrace.currentSession != 0) {
        return;
    }
    
    // The SDK doesn't expose excess methods when developers won't ever need to use.
    // Lucky we have Objective-C runtime to help!
    if ([[BRTrace class] respondsToSelector:@selector(reset)]) {
        // This gets unit tested
        [[BRTrace class] performSelector:@selector(reset)]; // adds current time
    } else {
        // Objective-c logger wrapper
        Class logger = NSClassFromString(@"BRLoggerObjc");
        
        if ([logger class]) {
            if ([[logger class] respondsToSelector:@selector(print:for:)]) {
                // Avoid unnecessary Xcode warnings
                #pragma GCC diagnostic ignored "-Wundeclared-selector"
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Wundeclared-selector"
                // Calls print log with the obj-c method signature
                [logger performSelector:@selector(print:for:)
                                        withObject:@"Bitrise Trace does not respond to reset() method"
                                        withObject:@"launch"
                ];
                #pragma clang diagnostic pop
            } else {
                NSLog(@"[Bitrise:Trace/internalError] BRLoggerObjc print method does not exist");
            }
        } else {
            NSLog(@"[Bitrise:Trace/internalError] BRLoggerObjc class does not exist");
        }
    }
    
    // Start SDK
    (void)[BRTrace shared];
}

/// :nodoc:
__attribute__((destructor)) static void ObjectiveCOnlyUnload() {
    if (BRTrace.configuration.enabled == NO) {
        NSLog(@"[Bitrise:Trace/launch] SDK disabled");
        
        return;
    }
    
    // Same logs as above
    Class logger = NSClassFromString(@"BRLoggerObjc");
    
    if ([logger class]) {
        if ([[logger class] respondsToSelector:@selector(print:for:)]) {
            #pragma GCC diagnostic ignored "-Wundeclared-selector"
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            [logger performSelector:@selector(print:for:)
                                    withObject:@"Bitrise Trace unloaded using library destructor"
                                    withObject:@"launch"
            ];
            #pragma clang diagnostic pop
        } else {
            NSLog(@"[Bitrise:Trace/internalError] BRLoggerObjc print method does not exist");
        }
    } else {
        NSLog(@"[Bitrise:Trace/internalError] BRLoggerObjc class does not exist");
    }
}

#pragma mark - ObjectiveCOnlyLoadUsingClassMethod

/// First attempt at starting SDK
/// This class gets called first when the SDK moved into memory as the runtime
/// try to find all classes with `load` class method
/// In Xcode build settings the file is the first one to get processed and called
@interface ObjectiveCOnlyLoadUsingClassMethod : NSObject

+ (void)load;

@end

@implementation ObjectiveCOnlyLoadUsingClassMethod

+ (void)load {
    ObjectiveCOnlyLoad();
}

@end
    

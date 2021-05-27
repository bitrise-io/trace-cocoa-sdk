//
//  BRObjectiveCOnlyLoad.m
//  TraceInternal
//
//  Created by Shams Ahmed on 08/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<Trace/Trace-Swift.h>)
#import <Trace/Trace-Swift.h> // Framework
#elif __has_include(<Trace-Swift.h>)
#import <Trace-Swift.h> // Static library
#endif

#pragma mark - Logs

static void BITRISE_WILL_LOAD_TRACE_USING_CONSTRUCTOR() {
 
}

static void BITRISE_DID_LOAD_TRACE_USING_CONSTRUCTOR() {
 
}

#pragma mark - Constructor/Destructor

/// Second attempt at starting SDK
/// Using library constructor to start the SDK
/// By default when the SDK is moved to memory the SDK `constructor` method is called
#pragma GCC diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
__attribute__((constructor)) static void BRInternalObjectiveCOnlyLoad(void) {
    BITRISE_WILL_LOAD_TRACE_USING_CONSTRUCTOR();
    
    // The SDK doesn't expose excess methods when developers won't ever need to use.
    // Lucky we have Objective-C runtime to help!
    Class Trace = NSClassFromString(@"BRTrace");
    
    if (!Trace) {
        Trace = NSClassFromString(@"Trace");
    }
    
    if (Trace) {
        @try {
            BOOL isTraceEnabled = [[Trace valueForKeyPath:@"configuration.enabled"] boolValue];
            
            if (isTraceEnabled == NO) {
                NSLog(@"[Bitrise:Trace/launch] SDK disabled");

                return;
            }
            
            NSInteger currentSession = [[Trace valueForKey:@"currentSession"] integerValue];

            // Update session timeout values only if the SDK hasn't been started yet
            if (currentSession != 0) {
                if ([Trace respondsToSelector:@selector(shared)]) {
                    (void)[Trace performSelector:@selector(shared)]; // Start SDK
                } else {
                    NSLog(@"[Bitrise:Trace/internalError] Failed to start SDK since BRTrace.shared has not been found");
                }
                
                return;
            }
        } @catch (NSException *exception) {
            NSLog(@"[Bitrise:Trace/internalError] BRTrace property does not exist");

            return;
        }
    } else {
        NSLog(@"[Bitrise:Trace/internalError] BRTrace class does not exist");
        
        return;
    }

    if ([Trace respondsToSelector:@selector(reset)]) {
        [Trace performSelector:@selector(reset)]; // adds current time
    } else {
        // Objective-c logger wrapper
        Class logger = NSClassFromString(@"BRLoggerObjc");

        if (logger) {
            if ([logger respondsToSelector:@selector(print:for:)]) {
                // Calls print log with the obj-c method signature
                [logger performSelector:@selector(print:for:)
                                        withObject:@"Bitrise Trace does not respond to reset() method"
                                        withObject:@"launch"
                ];
            } else {
                NSLog(@"[Bitrise:Trace/internalError] BRLoggerObjc print method does not exist");
            }
        } else {
            NSLog(@"[Bitrise:Trace/internalError] BRLoggerObjc class does not exist");
        }
    }

    if ([Trace respondsToSelector:@selector(shared)]) {
        (void)[Trace performSelector:@selector(shared)]; // Start SDK
    } else {
        NSLog(@"[Bitrise:Trace/internalError] Failed to start SDK since BRTrace.shared has not been found");
    }
}

/// :nodoc:
__attribute__((destructor)) static void BRInternalObjectiveCOnlyUnload() {
    // The SDK doesn't expose excess methods when developers won't ever need to use.
    // Lucky we have Objective-C runtime to help!
    Class Trace = NSClassFromString(@"BRTrace");
    
    @try {
        BOOL isTraceEnabled = [[Trace valueForKeyPath:@"configuration.enabled"] boolValue];
        
        if (isTraceEnabled == NO) {
            NSLog(@"[Bitrise:Trace/launch] SDK disabled");

            return;
        }
    } @catch (NSException *exception) {
        NSLog(@"[Bitrise:Trace/internalError] BRTrace.configuration.enabled property does not exist");

        return;
    }
    
    // Same logs as above
    Class logger = NSClassFromString(@"BRLoggerObjc");
    
    if (logger) {
        if ([logger respondsToSelector:@selector(print:for:)]) {
            [logger performSelector:@selector(print:for:)
                                    withObject:@"Bitrise Trace unloaded using library destructor"
                                    withObject:@"launch"
            ];
        } else {
            NSLog(@"[Bitrise:Trace/internalError] BRLoggerObjc print method does not exist");
        }
    } else {
        NSLog(@"[Bitrise:Trace/internalError] BRLoggerObjc class does not exist");
    }
    
    BITRISE_DID_LOAD_TRACE_USING_CONSTRUCTOR();
}

#pragma clang diagnostic pop

#pragma mark - Logging

static void BITRISE_WILL_LOAD_TRACE() {
 
}

static void BITRISE_DID_LOAD_TRACE() {
 
}

#pragma mark - BRInternalObjectiveCOnlyLoadUsingClassMethod

/// First attempt at starting SDK
/// This class gets called first when the SDK moved into memory as the runtime
/// try to find all classes with `load` class method
/// In Xcode build settings the file is the first one to get processed and called
@interface BRInternalObjectiveCOnlyLoadUsingClassMethod : NSObject

#pragma mark - Load

+ (void)load;

@end

@implementation BRInternalObjectiveCOnlyLoadUsingClassMethod

#pragma mark - Load

+ (void)load {
    BITRISE_WILL_LOAD_TRACE();
    
    BRInternalObjectiveCOnlyLoad();
    
    BITRISE_DID_LOAD_TRACE();
}

@end

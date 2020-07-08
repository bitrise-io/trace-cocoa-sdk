//
//  ObjectiveCOnlyLoad.m
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<Trace/Trace-Swift.h>)
#import <Trace/Trace-Swift.h> // Framework
#else
#import <Trace-Swift.h> // Static library
#endif

/// :nodoc:
__attribute__((constructor)) static void ObjectiveCOnlyLoad(void) {
    // The SDK doesn't expose excess methods when developers won't need to use.
    // Lucky we have Objective-C runtime to help!
   
    // This gets unit tested
    [[BRTrace class] performSelector:@selector(reset)]; // adds current time
    
    // Start SDK
    (void)[BRTrace shared];
}

/// :nodoc:
__attribute__((destructor)) static void ObjectiveCOnlyUnload() {
    // Same logs as above
    Class logger = NSClassFromString(@"BRLoggerObjc");
    
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    [logger performSelector:@selector(print:for:)
                            withObject:@"Bitrise Trace unloaded using library destructor"
                            withObject:@"launch"
    ];
    #pragma clang diagnostic pop
}

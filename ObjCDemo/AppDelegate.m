//
//  AppDelegate.m
//  ObjCDemo
//
//  Created by Shams Ahmed on 06/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#pragma mark - UIApplicationDelegate lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    
}

@end

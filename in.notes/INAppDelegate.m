//
//  INAppDelegate.m
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INAppDelegate.h"

@interface INAppDelegate ()

- (void)setupAppearance;

@end

@implementation INAppDelegate

- (void)setupAppearance
{
    [[UINavigationBar appearance]setTintColor:[UIColor darkGrayColor]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAppearance];
    [MagicalRecord setupCoreDataStack];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // ...
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // ...
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // ...
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // ...
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // ...
}

@end

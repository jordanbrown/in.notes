//
//  INAppDelegate.m
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INAppDelegate.h"
#import "INPost+Manage.h"

@interface INAppDelegate ()

- (void)bootstrapInitialData;
- (void)setupAppearance;

@end

@implementation INAppDelegate

#pragma mark - Setup

- (void)bootstrapInitialData
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:kINBootstrappedInitialData]) {
        [INPost bootstrapInitialPostData];
    }
}

- (void)setupAppearance
{
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setBarTintColor:IN_NOTES_DEFAULT_APP_COLOR];
        
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:19], NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStack];
    [self bootstrapInitialData];
    [self setupAppearance];
    
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

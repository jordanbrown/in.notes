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

- (void)writeToFile
{
    NSString *quotesFile = [[NSBundle mainBundle]pathForResource:@"quotes" ofType:@"plist"];
    NSArray *quotes = [[NSArray alloc]initWithContentsOfFile:quotesFile];
    
    NSUInteger random = arc4random() % [quotes count];
    
    NSLog(@"%@", [quotes objectAtIndex:random]);
}

- (void)setupAppearance
{
    [[UINavigationBar appearance]setTintColor:[UIColor darkGrayColor]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStack];
    [self bootstrapInitialData];
    [self setupAppearance];
    
    [self writeToFile];
    
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

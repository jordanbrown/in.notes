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
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20],
                                 NSForegroundColorAttributeName : [UIColor whiteColor], NSUnderlineStyleAttributeName : @3};
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UINavigationBar appearance]setBackIndicatorImage:[UIImage imageNamed:@"back-button-alt"]];
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back-button-alt"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:INMigratingSqliteStoreName];
    [self bootstrapInitialData];
    [self setupAppearance];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSManagedObjectContext defaultContext]save:nil];
    [[NSManagedObjectContext rootSavingContext]save:nil];
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

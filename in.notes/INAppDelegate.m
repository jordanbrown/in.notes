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

- (void)setupAppearance;

@end

@implementation INAppDelegate

#pragma mark - Setup

- (void)setupAppearance {
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setBarTintColor:IN_NOTES_DEFAULT_APP_COLOR];
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20],
                                 NSForegroundColorAttributeName : [UIColor whiteColor], NSUnderlineStyleAttributeName : @3};
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UINavigationBar appearance]setBackIndicatorImage:[UIImage imageNamed:@"back-button-alt"]];
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back-button-alt"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAppearance]; return YES;
}

-(void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data Stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"in.notes" withExtension:@"momd"];
}

- (NSURL *)storeURL {
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"in.notes.sqlite"];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelURL]];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error]) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            dictionary[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dictionary[NSLocalizedFailureReasonErrorKey] = failureReason;
            dictionary[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dictionary];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (!coordinator) {
            return nil;
        }
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

#pragma mark - Core Data Saving

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

@end

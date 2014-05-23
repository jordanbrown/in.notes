//
//  INPost+Manage.m
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INPost+Manage.h"

@implementation INPost (Manage)

+ (void)bootstrapInitialPostData
{
    [self postWithText:kINBootstrapInitialText
                 image:[UIImage imageNamed:kINBootstrapInitialImage]
             thumbnail:[UIImage imageNamed:kINBootstrapInitialThumbnail]
              hashtags:nil
            completion:^(NSError *error) {
                
                if (!error) {
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kINBootstrappedInitialData];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }];
}

+ (void)postWithText:(NSString *)text image:(UIImage *)image thumbnail:(UIImage *)thumbnail hashtags:(NSArray *)hashtags completion:(INPostCompletionHandler)completionHandler
{
    INPost *post = [INPost createEntity];
    post.text = text;
    post.image = UIImageJPEGRepresentation(image, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY);
    post.thumbnail = UIImageJPEGRepresentation(thumbnail, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY);
    post.date = [NSDate date];
    post.uuid = [[NSUUID UUID]UUIDString];
    post.hashtags = [NSKeyedArchiver archivedDataWithRootObject:hashtags];
    post.isArchived = @NO;
    post.type = [self postTypeForText:text image:image];
    
    NSError *error = nil;
    [post.managedObjectContext save:&error];
    
    if ([[INPost findAll]count] == 1) { [[NSNotificationCenter defaultCenter]postNotificationName:kINManagedObjectContextDidAddNewItem object:nil]; }
    if (error) { completionHandler(error); }
    if (!error) { completionHandler(nil); }
}

+ (void)editPost:(INPost *)post withText:(NSString *)text image:(UIImage *)image thumbnail:(UIImage *)thumbnail hashtags:(NSArray *)hashtags completion:(INPostCompletionHandler)completionHandler
{
    if (image) { post.image = UIImageJPEGRepresentation(image, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY); }
    if (thumbnail) { post.thumbnail = thumbnail ?  UIImageJPEGRepresentation(thumbnail, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY) : post.thumbnail; }
    post.text = text;
    post.hashtags = [NSKeyedArchiver archivedDataWithRootObject:hashtags];
    post.type = [self postTypeForText:text image:image];
    
    NSError *error = nil;
    [post.managedObjectContext save:&error];
    
    if (error) { completionHandler(error); }
    if (!error) { completionHandler(nil); }
}

+ (void)deletePost:(INPost *)post completion:(INPostCompletionHandler)completionHandler
{
    [post.managedObjectContext deleteObject:post];
    
    if ([[INPost findAll]count] == 0) { [[NSNotificationCenter defaultCenter]postNotificationName:kINManagedObjectContextDidDeleteLastItem object:nil]; }
    completionHandler(nil);
}

#pragma mark - Helper Methods 

+ (NSNumber *)postTypeForText:(NSString *)text image:(id)image
{
    NSNumber *kind = nil;
    
    if (image && [text length] > 0) {
        kind = @1; // Text & Image.
    } else if ([text length] > 0 && !image) {
        kind = @2; // Text only.
    } else if ([text length] == 0 && image) {
        kind = @3; // Image only.
    }
    
    return kind;
}

@end

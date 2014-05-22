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
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
        
        INPost *post = [INPost createInContext:localContext];
        post.text = text;
        post.image = UIImageJPEGRepresentation(image, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY);
        post.thumbnail = UIImageJPEGRepresentation(thumbnail, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY);
        post.date = [NSDate date];
        post.uuid = [[NSUUID UUID]UUIDString];
        post.hashtags = [NSKeyedArchiver archivedDataWithRootObject:hashtags];
        post.isArchived = @NO;
        post.type = [self postTypeForText:text image:image];
        
    } completion:^(BOOL success, NSError *error) {
        if (!error) {
            
            // At this point I am only intersted in being notified when the first item is added.
            if ([[INPost findAll]count] == 1) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kINManagedObjectContextDidAddNewItem object:nil];
            }
            
            completionHandler (nil);
        } else {
            completionHandler(error);
        }
    }];
}

+ (void)editPost:(INPost *)post withText:(NSString *)text image:(UIImage *)image thumbnail:(UIImage *)thumbnail hashtags:(NSArray *)hashtags completion:(INPostCompletionHandler)completionHandler
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
        
        post.text = text;
        
    } completion:^(BOOL success, NSError *error) {
        if (!error) {
            
            completionHandler(nil);
            
        } else {
            
            completionHandler(error);
            
        }
    }];
}

+ (void)deletePost:(INPost *)post completion:(INPostCompletionHandler)completionHandler
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
        [localContext deleteObject:post];
    } completion:^(BOOL success, NSError *error) {
        
        // At this point I am only interested in being notified when the last item is deleted.
        if (!error && [[INPost findAll]count] == 0) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kINManagedObjectContextDidDeleteLastItem object:nil];
            
            completionHandler(nil);
            
        } else if (!error) {
            
            completionHandler(nil);
            
        }
        
    }];
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

// Creating a "pointer" copy and then deleting "original" post will nill out the pointer.
// Hard copy / manual copy / is required in order to be able to pull relevant data.
+ (INPost *)copy:(INPost *)post
{
    INPost *copyPost = [INPost createEntity];
    copyPost.date = post.date;
    copyPost.hashtags = post.hashtags;
    copyPost.image = post.image;
    copyPost.text = post.text;
    copyPost.thumbnail = post.thumbnail;
    copyPost.type = post.type;
    copyPost.uuid = post.uuid;
    copyPost.isArchived = post.isArchived;
    
    return copyPost;
}

@end

//
//  INPost+Manage.m
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INPost+Manage.h"

@implementation INPost (Manage)

+ (void)postWithText:(NSString *)text image:(UIImage *)image thumbnail:(UIImage *)thumbnail hashtags:(NSArray *)hashtags context:(NSManagedObjectContext *)context {
    INPost *post = [NSEntityDescription insertNewObjectForEntityForName:kINPostEntity inManagedObjectContext:context];
    post.text = text;
    post.image = UIImageJPEGRepresentation(image, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY);
    post.thumbnail = UIImageJPEGRepresentation(thumbnail, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY);
    post.date = [NSDate date];
    post.uuid = [[NSUUID UUID]UUIDString];
    post.hashtags = [NSKeyedArchiver archivedDataWithRootObject:hashtags];
    post.isArchived = @NO;
    post.type = [self postTypeForText:text image:image];
    
    
    [context save:nil];
//    [context.parentContext save:&error];
    
    if (![self isEmpty:context]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kINManagedObjectContextDidAddNewItem object:nil];
    }
}

+ (void)editPost:(INPost *)post withText:(NSString *)text image:(UIImage *)image thumbnail:(UIImage *)thumbnail hashtags:(NSArray *)hashtags context:(NSManagedObjectContext *)context {
    if (image) { post.image = UIImageJPEGRepresentation(image, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY); }
    if (thumbnail) { post.thumbnail = thumbnail ?  UIImageJPEGRepresentation(thumbnail, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY) : post.thumbnail; }
    post.text = text;
    post.hashtags = [NSKeyedArchiver archivedDataWithRootObject:hashtags];
    post.type = [self postTypeForText:text image:image];
    
    [context save:nil];
//    [context.parentContext save:&error];
}

+ (void)deletePost:(INPost *)post context:(NSManagedObjectContext *)context {
    [context deleteObject:post];
    [context save:nil];
    [context.parentContext save:nil];
    
    if ([self isEmpty:context]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kINManagedObjectContextDidDeleteLastItem object:nil];
    }
}

#pragma mark - Helper Methods 

+ (BOOL)isEmpty:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kINPostEntity];
    NSError *error = nil;
    
    BOOL isEmpty = NO;
    
    NSArray *notes = [context executeFetchRequest:request error:&error];
    if (!error && [notes count] == 0) {
        isEmpty = YES;
    } else if (!error && [notes count] > 0) {
        isEmpty = NO;
    }
    
    return isEmpty;
}

+ (NSNumber *)postTypeForText:(NSString *)text image:(id)image {
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

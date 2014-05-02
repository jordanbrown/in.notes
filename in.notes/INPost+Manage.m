//
//  INPost+Manage.m
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INPost+Manage.h"

@implementation INPost (Manage)

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
        
    } completion:^(BOOL success, NSError *error) {
        if (!error) {
            
            completionHandler (nil);
            
        } else {
            
            completionHandler(error);
            
        }
    }];
}

@end

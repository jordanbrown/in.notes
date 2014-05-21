//
//  INPost+Manage.h
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INPost.h"

/**
 *  CompletionHandler for INPost+Manage. While it only offers a pointer to an
 *  error, checking against it will provide all the info I need to assume
 *  the operation went well.
 *
 *  @param error object containing the error.
 */
typedef void(^INPostCompletionHandler)(NSError *error);

/**
 *  Enum for INPostType. See postTypeForText:image: implementation
 *  in the .m file for more information.
 */
typedef enum : NSUInteger {
    
    kINPostTypeComplete = 1,
    kINPostTypeText = 2,
    kINPostTypeImage = 3,
    
} kINPostType;

@interface INPost (Manage)

+ (void)bootstrapInitialPostData;

+ (void)postWithText:(NSString *)text image:(UIImage *)image thumbnail:(UIImage *)thumbnail hashtags:(NSArray *)hashtags completion:(INPostCompletionHandler)completionHandler;

+ (void)editPost:(INPost *)post withText:(NSString *)text image:(UIImage *)image thumbnail:(UIImage *)thumbnail hashtags:(NSArray *)hashtags completion:(INPostCompletionHandler)completionHandler;

+ (void)deletePost:(INPost *)post;

@end

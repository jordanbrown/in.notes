//
//  INPost+Manage.h
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INPost.h"

typedef void(^INPostCompletionHandler)(NSError *error);

@interface INPost (Manage)

+ (void)postWithText:(NSString *)text image:(UIImage *)image thumbnail:(UIImage *)thumbnail hashtags:(NSArray *)hashtags completion:(INPostCompletionHandler)completionHandler;

@end

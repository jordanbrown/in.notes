//
//  MCMacciTiFakeModel.h
//  FakeModel
//
//  Created by iC on 4/2/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCMacciTiFakeModel : NSObject

// User information. In real life, this probably needs its own class.
@property (strong ,nonatomic) NSString *userHandle;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) UIImage *userThumbnail;

// Post information.
@property (strong, nonatomic) NSString *postText;
@property (strong, nonatomic) UIImage *postImage;

+ (instancetype)randomModel;

@end

//
//  INTableViewCell.m
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INTableViewCell.h"
#import "INPost.h"

@implementation INTableViewCell

+ (NSString *)reuseIdentifier
{
    static NSString *reuseIdentifier = nil;
    if (!reuseIdentifier) {
        reuseIdentifier = NSStringFromClass([self class]);
    }
    return reuseIdentifier;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:[self reuseIdentifier] bundle:[NSBundle mainBundle]];
}

+ (NSString *)className
{
    static NSString *className = nil;
    if (!className) {
        className = NSStringFromClass([self class]);
    }
    return className;
}

+ (CGFloat)estimateCellHeight
{
    return 120.0f;
}

#pragma mark - Instance

- (void)setPost:(INPost *)post
{
    [self.txtLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.txtLabel setText:post.text];
    
    [self.thumbnail.layer setMasksToBounds:YES];
    [self.thumbnail.layer setCornerRadius:1.0];
    [self.thumbnail setImage:[UIImage imageWithData:post.thumbnail]];
    
    _post = post;
}

@end

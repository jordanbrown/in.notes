//
//  INImageTableViewCell.m
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INImageTableViewCell.h"
#import "INPost.h"

@implementation INImageTableViewCell

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

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.thumbnail.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.thumbnail removeGestureRecognizer:(UITapGestureRecognizer *)obj];
    }];
    
    return [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.delegate thumbnail:self.thumbnail didSelectThumbnailImageView:tapGestureRecognizer];
}

- (void)setPost:(INPost *)post
{
    [self.thumbnail.layer setMasksToBounds:YES];
    [self.thumbnail.layer setCornerRadius:1.0];
    [self.thumbnail setImage:[UIImage imageWithData:post.thumbnail]];
    [self.thumbnail setUserInteractionEnabled:YES];
    [self.thumbnail addGestureRecognizer:[self tapGestureRecognizer]];
    
    _post = post;
}

@end

//
//  INTextTableViewCell.m
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INTextTableViewCell.h"
#import "INPost.h"

@interface INTextTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

@end

@implementation INTextTableViewCell

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
    return 100.0f;
}

#pragma mark - Instance

- (void)setPost:(INPost *)post
{
    /**
     *  The initial font size is set here. However, if the user decides
     *  to change font size, reloadData on table view is called in the FeedVC.
     */
    self.txtLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.txtLabel.text = post.text;

    _post = post;
}

@end

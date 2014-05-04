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

@property (strong, nonatomic) NSIndexPath *indexPath;
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

- (void)setPost:(INPost *)post indexPath:(NSIndexPath *)indexPath
{
    [self.txtLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.txtLabel setText:post.text];
    
    [self setIndexPath:indexPath];

    _post = post;
}

@end

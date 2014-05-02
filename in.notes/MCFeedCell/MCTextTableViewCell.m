//
//  MCTextTableViewCell.m
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCTextTableViewCell.h"

@interface MCTextTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@property (weak, nonatomic) IBOutlet UILabel *postText;

- (IBAction)commentButtonSelected:(id)sender;

@end

@implementation MCTextTableViewCell

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
    return 60.0f;
}

#pragma mark - Instance

- (void)setData:(MCPost *)data
{
    // The initial font size is set here. However, if the user decides
    // to change font size, reloadData on table view is called in the FeedVC.
    self.postText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.userAvatar.image = [UIImage imageNamed:@"jim-circle"];
    self.userHandle.text = @"@michael";
    self.postText.text = data.text;
    
    // Setter stuff.
    _data = data;
}

- (IBAction)commentButtonSelected:(id)sender
{
    [self.textCellDelegate userDidSelectTextCommentButton:sender];
}

@end

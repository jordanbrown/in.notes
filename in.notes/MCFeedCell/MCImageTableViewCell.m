//
//  MCImageTableViewCell.m
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCImageTableViewCell.h"

@interface MCImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@end

@implementation MCImageTableViewCell

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureTapGestureRecognizer];
}

- (void)configureTapGestureRecognizer
{
    UITapGestureRecognizer *tapGesture = nil;
    if (!tapGesture) {
        tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        self.postImage.userInteractionEnabled = YES;
        
        [self.postImage addGestureRecognizer:tapGesture];
    }
}

- (void)setData:(MCPost *)post
{
    // The initial font size is set here. However, if the user decides
    // to change font size, reloadData on table view is called in the FeedVC.
    self.postText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.postText.text = @"";
    self.postImage.image = [UIImage imageNamed:@"cell-thumb-placeholder"];

    _post = post;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [self.imageCellDelegate userDidSelectImageView:self.postImage indexPath:self.indexPath];
        
    }
}

@end

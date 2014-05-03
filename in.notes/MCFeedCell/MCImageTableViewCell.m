//
//  MCImageTableViewCell.m
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCImageTableViewCell.h"
#import "INPost.h"

@interface MCImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

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
        self.thumbnail.userInteractionEnabled = YES;
        
        [self.thumbnail addGestureRecognizer:tapGesture];
    }
}

- (void)setData:(INPost *)post
{
    /**
     *  The initial font size is set here. However, if the user decides
     *  to change font size, reloadData on table view is called in the FeedVC.
     */
    self.txtLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    [self.thumbnail.layer setMasksToBounds:YES];
    [self.thumbnail.layer setCornerRadius:1.0];
    
    self.txtLabel.text = post.text;
    self.thumbnail.image = [UIImage imageWithData:post.thumbnail];

    _post = post;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [self.imageCellDelegate userDidSelectImageView:self.thumbnail indexPath:self.indexPath];
        
    }
}

@end

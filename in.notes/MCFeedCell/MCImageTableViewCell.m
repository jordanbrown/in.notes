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
    
    MCUser *user = [MCUser user];
    
    self.userAvatar.image = [UIImage imageWithData:user.thumbnail];
    self.userHandle.text = [self usernameForUsername:user.username];
    self.postText.text = post.text;
    
    [self.postImage.layer setCornerRadius:5.0];
    [self.postImage.layer setMasksToBounds:YES];
    
    [self.postImage setImageWithURL:[NSURL URLWithString:post.thumbnail]
                   placeholderImage:[UIImage imageNamed:kMCImageTableViewCellPlaceholder]
                            options:0
                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                               
                               // Update progress view...
                               
                           } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               
                               // Do nothing with the image... Allowing the SDWebImage handle caching.
                               
                           }];

    _post = post;
}

- (NSString *)usernameForUsername:(NSString *)username
{
    username = [username stringByReplacingOccurrencesOfString:@"twitter:" withString:@""];
    username = [username stringByReplacingOccurrencesOfString:@"facebook:" withString:@""];
    return username;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [self.imageCellDelegate userDidSelectImageView:self.postImage indexPath:self.indexPath];
        
    }
}

@end

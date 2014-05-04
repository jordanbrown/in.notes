//
//  INImageTableViewCell.m
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INImageTableViewCell.h"
#import "INPost.h"

@interface INImageTableViewCell ()

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@end

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

- (void)setPost:(INPost *)post indexPath:(NSIndexPath *)indexPath
{
    [self.txtLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.txtLabel setText:post.text];
    
    [self.thumbnail.layer setMasksToBounds:YES];
    [self.thumbnail.layer setCornerRadius:1.0];
    [self.thumbnail setImage:[UIImage imageWithData:post.thumbnail]];
    
    [self setIndexPath:indexPath];;

    _post = post;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.imageCellDelegate userDidSelectImageView:self.thumbnail indexPath:self.indexPath];
    }
}

@end

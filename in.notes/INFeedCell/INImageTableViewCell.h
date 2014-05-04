//
//  INImageTableViewCell.h
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INPost;

@protocol INImageTableViewCellDelegate <NSObject>

@optional
- (void)userDidSelectImageView:(UIImageView *)imageView indexPath:(NSIndexPath *)indexPath;

@end

@interface INImageTableViewCell : UITableViewCell

@property (weak, nonatomic) id <INImageTableViewCellDelegate> imageCellDelegate;
@property (weak, nonatomic) INPost *post;

+ (NSString *)reuseIdentifier;
+ (UINib *)nib;
+ (NSString *)className;
+ (CGFloat)estimateCellHeight;

- (void)setPost:(INPost *)post indexPath:(NSIndexPath *)indexPath;

@end

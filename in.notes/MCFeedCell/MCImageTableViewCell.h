//
//  MCImageTableViewCell.h
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCMoreOptionTableViewCell.h"

@class INPost;

@protocol MCImageTableViewCellDelegate <NSObject>

@optional
- (void)userDidSelectImageView:(UIImageView *)imageView indexPath:(NSIndexPath *)indexPath;

@end

@interface MCImageTableViewCell : MSCMoreOptionTableViewCell

@property (weak, nonatomic) id <MCImageTableViewCellDelegate> imageCellDelegate;
@property (weak, nonatomic) INPost *post;

@property (strong, nonatomic) NSIndexPath *indexPath;

+ (NSString *)reuseIdentifier;
+ (UINib *)nib;
+ (NSString *)className;
+ (CGFloat)estimateCellHeight;

- (void)setData:(INPost *)post;

@end

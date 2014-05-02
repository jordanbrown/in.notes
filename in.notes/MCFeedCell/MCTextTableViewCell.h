//
//  MCTextTableViewCell.h
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCPost;

@protocol MCTextTableViewCellDelegate <NSObject>

- (void)userDidSelectTextCommentButton:(id)sender;

@end

@interface MCTextTableViewCell : UITableViewCell

@property (weak, nonatomic) id <MCTextTableViewCellDelegate> textCellDelegate;
@property (strong, nonatomic) MCPost *data;

+ (NSString *)reuseIdentifier;
+ (UINib *)nib;
+ (NSString *)className;
+ (CGFloat)estimateCellHeight;

- (void)setData:(MCPost *)data;

@end

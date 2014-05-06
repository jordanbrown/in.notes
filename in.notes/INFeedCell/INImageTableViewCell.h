//
//  INImageTableViewCell.h
//  FakeModel
//
//  Created by iC on 4/3/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INThumbnailViewProtocol.h"

@class INPost;

@interface INImageTableViewCell : UITableViewCell

@property (weak, nonatomic) INPost *post;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (unsafe_unretained, nonatomic) id <INThumbnailViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

+ (NSString *)reuseIdentifier;
+ (UINib *)nib;
+ (NSString *)className;
+ (CGFloat)estimateCellHeight;

- (void)setPost:(INPost *)post;

@end

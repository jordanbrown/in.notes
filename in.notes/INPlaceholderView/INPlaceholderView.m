//
//  INPlaceholderView.m
//  in.notes
//
//  Created by iC on 5/7/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INPlaceholderView.h"

@implementation INPlaceholderView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame image:nil];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]];
        [self setAlpha:0.0];
        
        CGRect imageViewFrame = {
            .origin.x = frame.size.width / 2 - image.size.width / 2,
            .origin.y = frame.size.height / 2 - image.size.height / 2 - 64.0,
            .size.width = image.size.width,
            .size.height = image.size.height
        };
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageViewFrame];
        imageView.image = image;
        imageView.alpha = 0.2;
        
        [self addSubview:imageView];
        [self animateAlpha];
        
    }
    return self;
}

- (void)animateAlpha
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         self.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                             
                             //
                             
                         }
                     }];
}

@end

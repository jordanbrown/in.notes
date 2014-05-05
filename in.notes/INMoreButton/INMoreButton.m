//
//  INButton.m
//  in.notes
//
//  Created by iC on 3/17/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INMoreButton.h"

@interface INMoreButton ()

- (void)moreButtonSelected:(id)sender;

@end

@implementation INMoreButton

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame delegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<INMoreButtonDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:delegate];
        [self setImage:[UIImage imageNamed:@"more-button"]forState:UIControlStateNormal];
        [self addTarget:self action:@selector(moreButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)moveToPoint:(CGPoint)point
{
    [UIView animateWithDuration:IN_DEFAULT_ANIMATION_DURATION
                          delay:IN_DEFAULT_DELAY
         usingSpringWithDamping:IN_DEFAULT_SPRING_DAMPING
          initialSpringVelocity:IN_ZERO
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
                     } completion:nil];
}

- (void)moveToPoint:(CGPoint)point usingSpringWithDamping:(BOOL)usingSpring
{
    if (usingSpring) {
        [self moveToPoint:point];
    } else {
        [UIView animateWithDuration:IN_DEFAULT_ANIMATION_DURATION animations:^{
            self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
        }];
    }
}

#pragma mark - Delegate 

- (void)moreButtonSelected:(id)sender
{
    [self.delegate moreButtonSelected:sender];
}

@end

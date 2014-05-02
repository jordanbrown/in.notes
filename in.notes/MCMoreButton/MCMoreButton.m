//
//  MCButton.m
//  macciTi
//
//  Created by iC on 3/17/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCMoreButton.h"

@interface MCMoreButton ()

- (void)moreButtonSelected:(id)sender;

@end

@implementation MCMoreButton

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame delegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MCMoreButtonDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:delegate];
        [self setImage:[UIImage imageNamed:@"bttn-more"]forState:UIControlStateNormal];
        [self addTarget:self action:@selector(moreButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)moveToPoint:(CGPoint)point
{
    [UIView animateWithDuration:MC_DEFAULT_ANIMATION_DURATION
                          delay:MC_DEFAULT_DELAY
         usingSpringWithDamping:MC_DEFAULT_SPRING_DAMPING
          initialSpringVelocity:MC_ZERO
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
        [UIView animateWithDuration:MC_DEFAULT_ANIMATION_DURATION animations:^{
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

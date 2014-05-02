//
//  MCCharacterCounter.m
//  macciTi
//
//  Created by iC on 4/4/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCCharacterCounter.h"

#define ANIMATION_DURATION 2.0
#define ANIMATION_DELAY 2.0

@implementation MCCharacterCounter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0;
        self.text = @"240";
        self.textColor = [UIColor darkGrayColor];
        self.font = [UIFont systemFontOfSize:13.0];
        self.textAlignment = NSTextAlignmentRight;
        
        [self performFadeinAnimation];
    }
    return self;
}

- (void)performFadeinAnimation
{
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:ANIMATION_DELAY
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         // Nothing to do.
                     }];
}

@end

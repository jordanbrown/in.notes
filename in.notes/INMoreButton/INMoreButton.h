//
//  INButton.h
//  in.notes
//
//  Created by iC on 3/17/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IN_MORE_BUTTON_INIT_FRAME CGRectMake(self.view.frame.size.width / 2 - 30.0f, self.view.frame.size.height + 26.0f, 60.0f, 26.0f)
#define IN_MORE_BUTTON_INIT_FRAME_EDIT CGRectMake(130.0f, self.markdownTextView.frame.origin.y + self.markdownTextView.frame.size.height - 26.0f, 60.0f, 26.0f)
#define IN_MORE_BUTTON_ABOVE_KEYBOARD_POINT CGPointMake(130.0f, (self.markdownTextView.frame.origin.y + self.markdownTextView.frame.size.height))

@protocol INMoreButtonDelegate <NSObject>

- (void)moreButtonSelected:(id)sender;

@end

@interface INMoreButton : UIButton

@property (weak, nonatomic) id <INMoreButtonDelegate> delegate;

/**
 *  Methods for animating "location" of the button on the screen.
 *  Animation is done using spring damping by default. To move the button without spring damping,
 *  use animateToPoint:usingSpringWithDamping: NO.
 *
 *  @param point A point in view to where the button should move.
 */
- (void)moveToPoint:(CGPoint)point;
- (void)moveToPoint:(CGPoint)point usingSpringWithDamping:(BOOL)usingSpring;

/**
 *  Designated initializer.
 *
 *  @param frame    of the button.
 *  @param delegate for notification.
 *
 *  @return instance of the INMoreButton.
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id <INMoreButtonDelegate>)delegate;

@end

//
//  INAttachmentContainer.h
//  in.notes
//
//  Created by iC on 3/18/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INAttachmentView.h"

#define IN_ATTACHMENT_CONTAINER_INIT_FRAME CGRectMake(0.0f, self.view.frame.size.height + 216.0f, 320.0f, 216.0f)
#define IN_ATTACHMENT_CONTAINER_INIT_FRAME_EDIT CGRectMake(0.0f, self.view.frame.size.height - 216.0f, 320.0f, 216.0f)
#define IN_ATTACHMENT_VIEW_INIT_FRAME CGRectMake(10.0f, self.frame.size.height + 98.0f, 300.0f, 196.0f)
#define IN_ATTACHMENT_VIEW_SIZE CGSizeMake(300.0f, 196.0f)
#define IN_ATTACHMENT_VIEW_VISIBLE_FRAME CGRectMake(10.0f, 10.0f, 300.0f, 196.0f)

@protocol INAttachmentContainerDelegate <NSObject>

- (void)attachmentContainerDidRemoveImageWithRequest:(kINAttachmentRequest)request;

@end

@interface INAttachmentContainer : UIImageView

@property (strong, nonatomic, readonly) INAttachmentView *attachmentView;
@property (weak, nonatomic) id <INAttachmentContainerDelegate> delegate;

/**
 *  Method for setting attachemnt image inside of the container.
 *
 *  @param image selected by the user that should be set.
 */
- (void)setAttachmentImage:(UIImage *)image;

/**
 *  Methods for animating "location" of the attachment on the screen.
 *  Animation is done using spring damping by default. To move the attachemnt
 *  container without spring damping, use animateToPoint:usingSpringWithDamping: NO.
 *
 *  @param point A point in view to where the view should move.
 */
- (void)moveToPoint:(CGPoint)point;
- (void)moveToPoint:(CGPoint)point usingSpringWithDamping:(BOOL)usingSpring;

@end

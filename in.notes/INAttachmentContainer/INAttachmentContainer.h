//
//  INAttachmentContainer.h
//  in.notes
//
//  Created by iC on 3/18/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol INAttachmentContainerDelegate <NSObject>

- (void)attachmentContainerDidRemoveImageWithRequest:(kINAttachmentRequest)request;

@end

@interface INAttachmentContainer : UIImageView

@property (strong, nonatomic, readonly) AttachmentView *attachmentView;
@property (weak, nonatomic) id <INAttachmentContainerDelegate> delegate;

/**
 *  Method for setting attachemnt image inside of the container.
 *
 *  @param image selected by the user that should be set.
 */
- (void)setAttachmentImage:(UIImage *)image;
- (void)setAttachmentImage:(UIImage *)image usingSpringWithDamping:(BOOL)usingSpring;

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

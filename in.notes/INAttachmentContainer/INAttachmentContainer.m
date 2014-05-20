//
//  INAttachmentContainer.m
//  in.notes
//
//  Created by iC on 3/18/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INAttachmentContainer.h"

@interface INAttachmentContainer () <UICollisionBehaviorDelegate, INAttachmentViewDelegate>

@property (strong, nonatomic, readwrite) INAttachmentView *attachmentView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehaviour;

@end

@implementation INAttachmentContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"bg-attachment"]];
        [self setUserInteractionEnabled:YES];
        [self addSubview:self.attachmentView];
        [self addMotionEffectToView:self.attachmentView magnitude:3.0f];
        
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    }
    return self;
}

- (void)moveToPoint:(CGPoint)point
{
    [UIView animateWithDuration:IN_DEFAULT_ANIMATION_DURATION
                          delay:IN_ZERO
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

- (void)setAttachmentImage:(UIImage *)image
{
    [UIView animateWithDuration:IN_DEFAULT_ANIMATION_DURATION
                          delay:IN_ZERO
         usingSpringWithDamping:IN_DEFAULT_SPRING_DAMPING
          initialSpringVelocity:IN_ZERO
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.attachmentView setImage:[UIImage resizeImage:image toSize:IN_ATTACHMENT_VIEW_SIZE cornerRadius:1.0f]];
                         [self.attachmentView setFrame:IN_ATTACHMENT_VIEW_VISIBLE_FRAME];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             // NSLog(@"Attachment image is set with frame: %@", NSStringFromCGRect(self.attachmentView.frame));
                         }
                     }];
}

- (void)setAttachmentImage:(UIImage *)image usingSpringWithDamping:(BOOL)usingSpring
{
    if (usingSpring) {
        [self setAttachmentImage:image];
    } else {
        [self.attachmentView setImage:[UIImage resizeImage:image toSize:IN_ATTACHMENT_VIEW_SIZE cornerRadius:1.0f]];
        [self.attachmentView setFrame:IN_ATTACHMENT_VIEW_VISIBLE_FRAME];
    }
}

- (void)addMotionEffectToView:(UIView *)view magnitude:(CGFloat)magnitude
{
    UIInterpolatingMotionEffect *xMotion = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *yMotion = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    xMotion.minimumRelativeValue = @(-magnitude);
    xMotion.maximumRelativeValue = @(magnitude);
    yMotion.minimumRelativeValue = @(-magnitude);
    yMotion.maximumRelativeValue = @(magnitude);
    
    UIMotionEffectGroup *motionGroup = [[UIMotionEffectGroup alloc]init];
    motionGroup.motionEffects = @[xMotion, yMotion];
    
    [view addMotionEffect:motionGroup];
}

- (NSData *)imageDataForCurrentImage
{
    return UIImageJPEGRepresentation(self.attachmentView.image, 0.8);
}

- (NSString *)imageNameForParse
{
    return [[NSUUID UUID]UUIDString];
}

#pragma mark - INAttachment View

- (INAttachmentView *)attachmentView
{
    if (!_attachmentView) {
        _attachmentView = [[INAttachmentView alloc]initWithFrame:IN_ATTACHMENT_VIEW_INIT_FRAME delegate:self];
    }
    return _attachmentView;
}

- (void)didSelectActionSheetButtonAtIndex:(NSInteger)index
{
    [self resetDynamicAnimator]; // Before adding "another" behaviour, remove all previous ones. 
    
    if (index == kINAttachmentRequestRemoveImage) {
        [self resetAttachmentView];
        [self.delegate attachmentContainerDidRemoveImageWithRequest:kINAttachmentRequestRemoveImage];
    } else if (index == kINAttachmentRequestReplaceImage) {
        [self resetAttachmentView];
        [self.delegate attachmentContainerDidRemoveImageWithRequest:kINAttachmentRequestReplaceImage];
    } else if (index == kINAttachmentRequestCancel) {
        // Action was canceled. Nothing to do.
    }
}

- (void)resetAttachmentView
{
    UIView *intermediateView = [self.attachmentView snapshotViewAfterScreenUpdates:NO];
    
    [self insertSubview:intermediateView aboveSubview:self.attachmentView];
    [self.attachmentView setFrame:IN_ATTACHMENT_VIEW_INIT_FRAME];
    [self.attachmentView setImage:nil];
    
    self.gravity = [[UIGravityBehavior alloc]initWithItems:@[intermediateView]];
    self.itemBehaviour = [[UIDynamicItemBehavior alloc]initWithItems:@[intermediateView]];
    self.itemBehaviour.angularResistance = 1.0;
    
    [self.itemBehaviour addAngularVelocity:2.0 forItem:intermediateView];
    [self.animator addBehavior:self.itemBehaviour];
    [self.animator addBehavior:self.gravity];
}

- (void)resetDynamicAnimator
{
    [self.animator removeAllBehaviors];
}

@end

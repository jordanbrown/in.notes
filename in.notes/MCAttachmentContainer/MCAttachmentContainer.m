//
//  MCAttachmentContainer.m
//  macciTi
//
//  Created by iC on 3/18/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCAttachmentContainer.h"

@interface MCAttachmentContainer () <UICollisionBehaviorDelegate, MCAttachmentViewDelegate>

@property (strong, nonatomic, readwrite) MCAttachmentView *attachmentView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehaviour;

@end

@implementation MCAttachmentContainer

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
    [UIView animateWithDuration:MC_DEFAULT_ANIMATION_DURATION
                          delay:MC_ZERO
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

- (void)setAttachmentImage:(UIImage *)image
{
    [UIView animateWithDuration:MC_DEFAULT_ANIMATION_DURATION
                          delay:MC_ZERO
         usingSpringWithDamping:MC_DEFAULT_SPRING_DAMPING
          initialSpringVelocity:MC_ZERO
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.attachmentView setImage:[UIImage resizeImage:image toSize:MC_ATTACHMENT_VIEW_SIZE cornerRadius:0.0f]];
                         [self.attachmentView setFrame:MC_ATTACHMENT_VIEW_VISIBLE_FRAME];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             // NSLog(@"Attachment image is set with frame: %@", NSStringFromCGRect(self.attachmentView.frame));
                         }
                     }];
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

#pragma mark - MCAttachment View

- (MCAttachmentView *)attachmentView
{
    if (!_attachmentView) {
        _attachmentView = [[MCAttachmentView alloc]initWithFrame:MC_ATTACHMENT_VIEW_INIT_FRAME delegate:self];
    }
    return _attachmentView;
}

- (void)didSelectActionSheetButtonAtIndex:(NSInteger)index
{
    [self resetDynamicAnimator]; // Before adding "another" behaviour, remove all previous ones. 
    
    if (index == kMCAttachmentRequestRemoveImage) {
        [self resetAttachmentView];
        [self.delegate attachmentContainerDidRemoveImageWithRequest:kMCAttachmentRequestRemoveImage];
    } else if (index == kMCAttachmentRequestReplaceImage) {
        [self resetAttachmentView];
        [self.delegate attachmentContainerDidRemoveImageWithRequest:kMCAttachmentRequestReplaceImage];
    } else if (index == kMCAttachmentRequestCancel) {
        // Action was canceled. Nothing to do.
    }
}

- (void)resetAttachmentView
{
    UIView *intermediateView = [self.attachmentView snapshotViewAfterScreenUpdates:NO];
    
    [self insertSubview:intermediateView aboveSubview:self.attachmentView];
    [self.attachmentView setFrame:MC_ATTACHMENT_VIEW_INIT_FRAME];
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

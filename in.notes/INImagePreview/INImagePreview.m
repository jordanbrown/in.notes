//
//  INImagePreview.m
//  in.notes
//
//  Created by iC on 4/30/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INImagePreview.h"
#import "KHFlatButton.h"

#define IN_IN_ANIMATION_DURATION 0.6
#define IN_OUT_ANIMAITON_DURAITON 0.4
#define IN_SPRING_DAMPING 0.7

@interface INImagePreview ()

@property (weak, nonatomic) UIImage *image;
@property (strong, nonatomic) INImagePreviewCompletionHandler completion;
@property (weak, nonatomic) UIView *senderView;

@end

@implementation INImagePreview

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithImage:nil view:nil completion:nil];
}

- (instancetype)initWithImage:(UIImage *)image
{
    return [self initWithImage:image view:nil completion:nil];
}

- (instancetype)initWithImage:(UIImage *)image completion:(INImagePreviewCompletionHandler)completion
{
    return [self initWithImage:image view:nil completion:completion];
}

- (instancetype)initWithImage:(UIImage *)image view:(UIView *)view completion:(INImagePreviewCompletionHandler)completion
{
    self = [super initWithFrame:[[UIScreen mainScreen]bounds]];
    if (self) {
                
        [self setFrame:[[UIScreen mainScreen]bounds]];
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.0];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        
        KHFlatButton *shareButton = [KHFlatButton buttonWithFrame:CGRectMake(0.0, self.frame.size.height - 44.0, self.frame.size.width, 44.0)
                                                        withTitle:@"Share This Photo"
                                                  backgroundColor:[UIColor redColor]
                                                     cornerRadius:0.0];
        
        [shareButton addTarget:self action:@selector(shareButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setCompletion:completion];
        [self setSenderView:view];
        [self setImage:image];
        
        [self addSubview:imageView];
        [self addSubview:shareButton];
        [self addGestureRecognizer:tapGestureRecognizer];
        
    }
    return self;
}

- (void)previewImage
{
    [UIView animateWithDuration:IN_IN_ANIMATION_DURATION
                          delay:IN_ZERO
         usingSpringWithDamping:IN_SPRING_DAMPING
          initialSpringVelocity:IN_ZERO
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.alpha = 1.0;
                         self.senderView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         
                     } completion:nil];
}

- (void)handleTapGesture:(id)sender
{
    [UIView animateWithDuration:IN_OUT_ANIMAITON_DURAITON
                     animations:^{
                         
                         self.alpha = 0.0;
                         self.senderView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             
                             /**
                              *  If the completion was NOT set in the view controller initializing this view,
                              *  calling self.completion will BAD ACCESS.
                              */
                             if (self.completion) {
                                 
                                 self.completion();
                                 
                             }
                             
                         }
                         
                     }];
}

- (void)shareButtonSelected:(id)sender
{
    [self handleTapGesture:nil];
    [self.delegate imagePreviewDidFinishPreparingImage:self.image];
    
    [self setImage:nil]; // Clearing image is required.
}

@end

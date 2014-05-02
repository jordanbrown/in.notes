//
//  MCImagePreview.h
//  macciTi
//
//  Created by iC on 4/30/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MCImagePreviewCompletionHandler)();

@protocol MCImagePreviewDelegate <NSObject>

- (void)imagePreviewDidFinishPreparingImage:(UIImage *)image;

@end

@interface MCImagePreview : UIView

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image completion:(MCImagePreviewCompletionHandler)completion;
- (instancetype)initWithImage:(UIImage *)image view:(UIView *)view completion:(MCImagePreviewCompletionHandler)completion;

- (void)previewImage;

@property (unsafe_unretained, nonatomic) id <MCImagePreviewDelegate> delegate;

@end

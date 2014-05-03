//
//  INImagePreview.h
//  in.notes
//
//  Created by iC on 4/30/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^INImagePreviewCompletionHandler)();

@protocol INImagePreviewDelegate <NSObject>

- (void)imagePreviewDidFinishPreparingImage:(UIImage *)image;

@end

@interface INImagePreview : UIView

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image completion:(INImagePreviewCompletionHandler)completion;
- (instancetype)initWithImage:(UIImage *)image view:(UIView *)view completion:(INImagePreviewCompletionHandler)completion;

- (void)previewImage;

@property (unsafe_unretained, nonatomic) id <INImagePreviewDelegate> delegate;

@end

//
//  MCAttachmentView.h
//  macciTi
//
//  Created by iC on 3/24/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  IMPORTANT: The order of these values in important.
 *  buttonAtIndex (action sheet) directly connects to value
 *  of the request.
 */
typedef enum : NSUInteger {
    kMCAttachmentRequestRemoveImage = 0,
    kMCAttachmentRequestReplaceImage = 1,
    kMCAttachmentRequestCancel = 2,
} kMCAttachmentRequest;

@protocol MCAttachmentViewDelegate <NSObject>

- (void)didSelectActionSheetButtonAtIndex:(NSInteger)index;

@end

@interface MCAttachmentView : UIImageView

@property (weak, nonatomic) id <MCAttachmentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MCAttachmentViewDelegate>)delegate;

@end

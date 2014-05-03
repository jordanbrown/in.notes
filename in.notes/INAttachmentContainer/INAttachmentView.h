//
//  INAttachmentView.h
//  in.notes
//
//  Created by iC on 3/24/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  IMPORTANT: The order of these values in important.
 *  buttonAtIndex (action sheet) directly connects to value
 *  of the request.
 */
typedef enum : NSUInteger {
    kINAttachmentRequestRemoveImage = 0,
    kINAttachmentRequestReplaceImage = 1,
    kINAttachmentRequestCancel = 2,
} kINAttachmentRequest;

@protocol INAttachmentViewDelegate <NSObject>

- (void)didSelectActionSheetButtonAtIndex:(NSInteger)index;

@end

@interface INAttachmentView : UIImageView

@property (weak, nonatomic) id <INAttachmentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<INAttachmentViewDelegate>)delegate;

@end

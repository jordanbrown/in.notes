//
//  MCAttachmentView.m
//  macciTi
//
//  Created by iC on 3/24/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCAttachmentView.h"
#import "REDActionSheet.h"

@interface MCAttachmentView ()

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture;

@end

@implementation MCAttachmentView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MCAttachmentViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        
        [tapGestureRecognizer addTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame delegate:nil];
}

- (void)handleTapGesture:(id)sender
{
    REDActionSheet *actionSheet = [[REDActionSheet alloc]initWithCancelButtonTitle:@"Cancel"
                                                            destructiveButtonTitle:@"Remove Image"
                                                             otherButtonTitlesList:@"Replace Image", nil];
    actionSheet.actionSheetTappedButtonAtIndexBlock = ^(REDActionSheet *actionSheet, NSUInteger buttonIndex) {
        [self.delegate didSelectActionSheetButtonAtIndex:buttonIndex];
    };
    [actionSheet showInView:self.superview];
}

@end

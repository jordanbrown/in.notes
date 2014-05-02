//
//  MCPostTextView.h
//  macciTi
//
//  Created by iC on 3/17/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MC_MARKDOWN_TEXT_VIEW_INIT_FRAME CGRectMake(5.0f, 64.0f, 310.0f, (self.view.frame.size.height - 64.0f) - (216.0f + self.moreButton.frame.size.height))
#define MC_MARKDOWN_TEXT_VIEW_BEHIND_KEYBOARD_FRAME CGRectMake(0.0f, self.view.frame.origin.y + 64.0f + self.markdownTextView.frame.size.height + self.moreButton.frame.size.height, 320.0f, 216.0f)

@protocol MCMarkdownTextViewDelegate <NSObject>

- (void)markdownTextViewDidUpdateCharactersCount:(int)count;

@end

@interface MCMarkdownTextView : UITextView

@property (weak, nonatomic) id <MCMarkdownTextViewDelegate> markdownDelegate;

@end

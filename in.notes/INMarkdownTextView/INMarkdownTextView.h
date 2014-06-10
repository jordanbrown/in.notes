//
//  INPostTextView.h
//  in.notes
//
//  Created by iC on 3/17/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IN_MARKDOWN_TEXT_VIEW_INIT_FRAME CGRectMake(5.0f, 0.0f, 310.0f, (self.view.frame.size.height - 64.0f) - 216.0f)
#define IN_MARKDOWN_TEXT_VIEW_BEHIND_KEYBOARD_FRAME CGRectMake(0.0f, self.view.frame.origin.y + 64.0f + self.markdownTextView.frame.size.height + self.moreButton.frame.size.height, 320.0f, 216.0f)

@protocol INMarkdownTextViewDelegate <NSObject>

- (void)markdownTextViewDidUpdateCharactersCount:(int)count;

@end

@interface INMarkdownTextView : UITextView

@property (weak, nonatomic) id <INMarkdownTextViewDelegate> markdownDelegate;

@end

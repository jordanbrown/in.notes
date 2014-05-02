//
//  MCPostTextView.m
//  macciTi
//
//  Created by iC on 3/17/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCMarkdownTextView.h"
#import "MCMarkdownSyntaxStorage.h"

#define MC_MAX_CHARACTERS_COUNT 240

static NSString * const kEmptyString = @"";

@interface MCMarkdownTextView () <UITextViewDelegate>

@property (strong, nonatomic) MCMarkdownSyntaxStorage *syntaxStorage;

@end

@implementation MCMarkdownTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:kEmptyString attributes:attributes];
    
    _syntaxStorage = [[MCMarkdownSyntaxStorage alloc]init];
    [_syntaxStorage appendAttributedString:attributedString];
    
    CGRect newFrame = frame;
    NSLayoutManager *manager = [[NSLayoutManager alloc]init];
    
    CGSize containerSize = CGSizeMake(newFrame.size.width, CGFLOAT_MAX);
    
    NSTextContainer *container = [[NSTextContainer alloc]initWithSize:containerSize];
    container.widthTracksTextView = YES;
    
    [manager addTextContainer:container];
    [_syntaxStorage addLayoutManager:manager];
    
    self = [super initWithFrame:frame textContainer:container];
    if (self) {
        self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        self.keyboardType = UIKeyboardTypeTwitter;
        self.delegate = self;
    }
    return self;
}

#pragma mark - Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    /**
     *  Only maximum characters allowed in a post. If user tries to add more,
     *  it simply wont work. Should also mention that the current limit of 240 characters
     *  looks / works great with the markdown container.
     */
    if (textView.text.length > MC_MAX_CHARACTERS_COUNT) {
        textView.text = [textView.text substringToIndex:MC_MAX_CHARACTERS_COUNT];
    }
    
    // Updating the delegate interested in knowing the characters count.
    [self.markdownDelegate markdownTextViewDidUpdateCharactersCount:MC_MAX_CHARACTERS_COUNT - (int)textView.text.length];
}

@end

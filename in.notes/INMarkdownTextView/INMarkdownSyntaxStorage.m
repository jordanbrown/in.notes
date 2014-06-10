//
//  INSyntaxHighlightTextStorage.m
//  in.notes
//
//  Created by iC on 3/13/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INMarkdownSyntaxStorage.h"

@interface INMarkdownSyntaxStorage ()

@property (strong, nonatomic) NSMutableAttributedString *backingStore;

@end

@implementation INMarkdownSyntaxStorage

- (instancetype)init
{
    self = [super init];
    if (self) {
        _backingStore = [[NSMutableAttributedString alloc]init];
    }
    return self;
}

- (NSString *)string
{
    return [self.backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [self.backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [self.backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    [self.backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)processEditing
{
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)range
{
    NSRange extendedRange = NSUnionRange(range, [[self.backingStore string]lineRangeForRange:NSMakeRange(NSMaxRange(range), 0)]);
    [self applyStylesToRange:extendedRange];
}

- (void)applyStylesToRange:(NSRange)searchRange
{
    // Create some fonts.
    UIFontDescriptor *fontDescriptior = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *boldFontDescriptor = [fontDescriptior fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont *boldFont = [UIFont fontWithDescriptor:boldFontDescriptor size:0.0];
    UIFont *normalFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    // Match items surrounded by asterisk.
    NSString *regexString = @"(#[A-Za-z0-9]+\\ )";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:0
                                                                             error:nil];
    NSDictionary *boldAttributes = @{NSFontAttributeName : boldFont, NSForegroundColorAttributeName : [UIColor blueColor]};
    NSDictionary *normalAttributes = @{NSFontAttributeName : normalFont, NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    
    // Iterate over each mathc, making text bold.
    [regex enumerateMatchesInString:[self.backingStore string]
                            options:0
                              range:searchRange
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             NSRange matchRange = [result range];
                             matchRange.length -= 1; // Fix for the first bold letter after the closing astersik.
                             
                             [self addAttributes:boldAttributes range:matchRange];
                             
                             // Reset style to the original
                             if (NSMaxRange(matchRange) + 1 < self.length) {
                                 [self addAttributes:normalAttributes range:NSMakeRange(NSMaxRange(matchRange) + 1, 1)];
                             }
                         }];
}


@end

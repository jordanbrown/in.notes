//
//  MarkdownSyntaxStorage.swift
//  in.notes
//
//  Created by Michael Babiy on 6/23/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

class MarkdownSyntaxStorage: NSTextStorage {
    
    var backingStore = NSMutableAttributedString()
    
    func string() -> String
    {
        return backingStore.string
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: CMutablePointer <NSRange>) -> NSDictionary!
    {
        return backingStore.attributesAtIndex(location, effectiveRange: range)
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String!)
    {
        beginEditing()
        backingStore.replaceCharactersInRange(range, withString: str)
        edited(NSTextStorageEditActions.EditedCharacters, range: range, changeInLength: str.utf16count - range.length)
        endEditing()
    }
    
    override func setAttributes(attrs: NSDictionary!, range: NSRange)
    {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(NSTextStorageEditActions.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    override func processEditing()
    {
        performReplacementsForRange(editedRange)
        super.processEditing()
    }
    
    func performReplacementsForRange(range: NSRange) -> Void
    {
        let string = backingStore.string as NSString // Casting is necessary.
        let extendedRange: NSRange = NSUnionRange(range, string.lineRangeForRange(NSMakeRange(NSMaxRange(range), 0)))
        applyStylesToRange(extendedRange)
    }
    
    func applyStylesToRange(range: NSRange) -> Void
    {
        let fontDescriptior = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let boldFontDescriptor = fontDescriptior.fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
        let boldFont = UIFont(descriptor: boldFontDescriptor, size: 0.0)
        let normalFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        let regexString = "(#[A-Za-z0-9]+\\ )"
        var error: NSError?
        let regex = NSRegularExpression(pattern: regexString, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
        
        if error {println(error!.localizedDescription)}
        
        let boldAttributes = [NSFontAttributeName : boldFont, NSForegroundColorAttributeName : UIColor.blueColor()]
        let normalAttributes = [NSFontAttributeName : normalFont, NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        
        regex.enumerateMatchesInString(string, options: NSMatchingOptions.ReportProgress, range: range, usingBlock: {
            result, flags, stop in
            if result {
                var matchRange = result.range
                matchRange.length -= 1
                self.addAttributes(boldAttributes, range: matchRange)
            }
        })
    }
    
}
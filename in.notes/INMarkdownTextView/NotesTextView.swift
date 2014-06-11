//
//  MarkdownTextView.swift
//  in.notes
//
//  Created by Michael Babiy on 6/4/14.
//  Copyright (c) 2014 Michael Babiy. All rights reserved.
//

import UIKit

let kKeyboardHeight: CGFloat = 216.0
let kPredictStripHeight: CGFloat = 39.0
let kEmptyString: String = ""

@objc protocol NotesTextViewDelegate
{
    func notesTextViewDidUpdateCharactersCount(count: Int)
}

@objc class NotesTextView: UITextView, UITextViewDelegate {
    
    var syntaxStorage: AnyObject! = INMarkdownSyntaxStorage()
    weak var markdownDelegate: NotesTextViewDelegate?
    
    init(view: UIView)
    {
        super.init(frame: frameForView(view), textContainer: textContainerWithFrame(frame))
        font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textColor = UIColor.darkGrayColor()
        self.delegate = self
    }
    
    func textContainerWithFrame(frame: CGRect) -> NSTextContainer
    {
        let attributes = [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        let attributedString = NSAttributedString(string:kEmptyString, attributes:attributes)
        syntaxStorage.appendAttributedString(attributedString)
        
        let newFrame = frame
        let manager = NSLayoutManager()
        
        let containerSize = CGSizeMake(newFrame.size.width, CGFLOAT_MAX)
        let container = NSTextContainer(size:containerSize)
        container.widthTracksTextView = true
        
        manager.addTextContainer(container)
        syntaxStorage.addLayoutManager(manager)
        
        return container
    }
    
    func frameForView(view: UIView) -> CGRect
    {
        var navigationBarOffset: CGFloat = 0.0
        
        if view.nextResponder().isKindOfClass(UIViewController) {
            let viewController: UIViewController = view.nextResponder() as UIViewController
            if viewController.parentViewController.isKindOfClass(UINavigationController) {
                navigationBarOffset = 64.0
            }
        }
        
        let textViewWidth: CGFloat = view.frame.size.width
        let textViewHeight: CGFloat = (view.frame.size.height - navigationBarOffset) - (kKeyboardHeight + kPredictStripHeight)
        
        return CGRectMake(0.0, 0.0, textViewWidth, textViewHeight)
    }
    
    func textViewDidChange(textView: UITextView!) -> Void
    {
        /**
        *  Only maximum characters allowed in a post. If user tries to add more,
        *  it simply wont work. Should also mention that the current limit of 240 characters
        *  looks / works great with the markdown container.
        */
        if (textView.text.bridgeToObjectiveC().length > 240) {
            textView.text = textView.text.substringToIndex(240)
        }
        
        // Updating the delegate interested in knowing the characters count.
        markdownDelegate?.notesTextViewDidUpdateCharactersCount(240 - textView.text.bridgeToObjectiveC().length)
    }
}
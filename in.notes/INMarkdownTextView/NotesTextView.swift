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

@objc class NotesTextView: UITextView, UITextViewDelegate {
    
    var syntaxStorage = INMarkdownSyntaxStorage()
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
        
    init(view: UIView) {
        super.init(frame: view.frame, textContainer: textContainerWithFrame(frame))
        font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textColor = UIColor.darkGrayColor()
    }
    
    func textContainerWithFrame(frame: CGRect) -> NSTextContainer {
        let attributes = [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        let attributedString = NSAttributedString(string:kEmptyString, attributes:attributes)
        syntaxStorage.appendAttributedString(attributedString)
        
        let newFrame = frame
        let manager = NSLayoutManager()
        
        let containerSize = CGSizeMake(newFrame.size.width, CGFloat.max)
        let container = NSTextContainer(size:containerSize)
        container.widthTracksTextView = true
        
        manager.addTextContainer(container)
        syntaxStorage.addLayoutManager(manager)
        
        return container
    }
    
}
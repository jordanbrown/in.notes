//
//  AttachmentView.swift
//  in.notes
//
//  Created by Michael Babiy on 6/24/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

@objc protocol AttachmentViewDelegate
{
    func didSelectActionSheetButtonAtIndex(index: Int)
}

class AttachmentView: UIImageView {
    
    weak var delegate: AttachmentViewDelegate?
    
    init(frame: CGRect, delegate: AttachmentViewDelegate?)
    {
        super.init(frame: frame)
        self.delegate = delegate
        userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        
        tapGestureRecognizer.addTarget(self, action: "handleTapGesture:")
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handleTapGesture(gesture: UITapGestureRecognizer) -> Void
    {
        let actionSheet = REDActionSheet(cancelButtonTitle: "Cancel",
                                         destructiveButtonTitle: "Remove Image",
                                         otherButtonTitle: "Replace Image")
        
        actionSheet.actionSheetTappedButtonAtIndexBlock = {
            aActionSheet, buttonIndex in
            self.delegate!.didSelectActionSheetButtonAtIndex(buttonIndex)
        }
        
        actionSheet.showInView(self.superview)
    }
}

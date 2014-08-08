//
//  ImagePreview.swift
//  in.notes
//
//  Created by Michael Babiy on 6/15/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

let IN_ANIMATION_DURATION: Float = 0.6
let OUT_ANIMATION_DURATION: Float = 0.4
let SPRING_DUMPING: Float = 0.7

typealias ImagePreviewCompletionHandler = () -> ()

@objc protocol ImagePreviewDelegate
{
    func imagePreviewDidFinishPreparingImage(view: ImagePreview, image: UIImage) -> Void
}

class ImagePreview: UIView {

    weak var delegate: ImagePreviewDelegate?
    weak var image: UIImage?
    weak var senderView: UIView?
    let completion: ImagePreviewCompletionHandler!
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(image: UIImage, view: UIView, completion:() -> ()) {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.frame = UIScreen.mainScreen().bounds
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.0
        
        let imageView: UIImageView = UIImageView(frame: self.frame)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = image
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        
        let shareButton: UIButton = UIButton(frame: CGRectMake(0.0, self.frame.size.height - 44.0, self.frame.size.width, 44.0))
        shareButton.titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        shareButton.setTitle("Share This Photo", forState: UIControlState.Normal)
        shareButton.backgroundColor = UIColor(red: 0.44, green: 0.51, blue: 0.6, alpha: 1.0)
        shareButton.addTarget(self, action: "shareButtonSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.completion = completion
        self.senderView = view
        self.image = image
        
        self.addSubview(imageView)
        self.addSubview(shareButton)
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func previewImage() -> Void {
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 1.0
            self.senderView!.transform = CGAffineTransformMakeScale(0.9, 0.9)
            }, completion:nil)
    }
    
    func handleTapGesture(sender: AnyObject?) -> Void {
        UIView.animateWithDuration(0.4, animations: {
            self.alpha = 0.0
            self.senderView!.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: {
                finished in
                if finished {
                    if self.completion {
                        self.completion()
                    }
                }
            })
    }
    
    func shareButtonSelected(sender: AnyObject) -> Void {
        handleTapGesture(nil)
        delegate!.imagePreviewDidFinishPreparingImage(self, image: self.image!)
        image = nil
    }
}

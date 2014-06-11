//
//  CharacterCounter.swift
//  in.notes
//
//  Created by Michael Babiy on 6/10/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

let kAnimationDuration = 2.0
let kAnimationDelay = 2.0

@objc class CharacterCounter: UILabel {

    init(frame: CGRect)
    {
        super.init(frame: frame)
        alpha = 0.0
        text = "240"
        textColor = UIColor.lightGrayColor()
        font = UIFont.systemFontOfSize(13.0)
        textAlignment = NSTextAlignment.Right
        
        performFadeinAnimation()
    }
    
    func performFadeinAnimation() -> Void
    {
        UIView.animateWithDuration(kAnimationDuration, delay: kAnimationDelay, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
}

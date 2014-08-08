//
//  PlaceholderView.swift
//  in.notes
//
//  Created by Michael Babiy on 6/24/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

@objc class PlaceholderView: UIView {
    
    let imageView: UIImageView!
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        alpha = 0.0
        
        let imageViewFrame = CGRectMake(frame.size.width / 2 - image.size.width / 2,
                                        frame.size.height / 2 - image.size.height / 2 - 64.0,
                                        image.size.width,
                                        image.size.height)
        
        imageView = UIImageView(frame: imageViewFrame)
        imageView.image = image
        imageView.alpha = 0.2
        
        addSubview(imageView)
        animateAlpha()
    }
    
    func animateAlpha() -> Void {
        UIView.animateWithDuration(0.4, animations: {
            self.alpha = 1.0
        })
    }
    
}


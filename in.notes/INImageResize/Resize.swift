//
//  Resize.swift
//  in.notes
//
//  Created by Michael Babiy on 6/10/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
    *  Method for resizing images with optional corner rounding.
    *  Specified image is resized first. Scaling ratio is calculated and
    *  the "new" image is drawn inside of the specified "new" image rect.
    *
    *  @param image        An image to be resized.
    *  @param size         A new size for the desired / resized / image.
    *  @param cornerRadius Corner radius of the image. Required.
    *
    *  @return Resized image with specified corner radius.
    */
    class func resizeImage(image: UIImage, toSize size:CGSize, cornerRadius radius:CGFloat) -> UIImage
    {
        let originalImageSize = image.size
        let newRect = CGRectMake(0.0, 0.0, size.width, size.height); // The rectangle of the new image.
        let ratio = max(newRect.size.width / originalImageSize.width, newRect.size.height / originalImageSize.height); // Figure out scaling ratio.
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0); // Creating transperant bitmap context with scaling factor equal to that of the screen.
        let path = UIBezierPath(roundedRect: newRect, cornerRadius: radius)
        path.addClip()
        
        var projectRect: CGRect = CGRectZero // Center the image in the thumbnail rectangle.
        projectRect.size.width = ratio * originalImageSize.width
        projectRect.size.height = ratio * originalImageSize.height
        projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0
        projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0
        
        image.drawInRect(projectRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

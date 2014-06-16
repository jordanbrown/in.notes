//
//  ImagePreview.swift
//  in.notes
//
//  Created by Michael Babiy on 6/15/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

@objc protocol ImagePreviewDelegate
{
    func imagePreviewDidFinishPreparingImage(view: ImagePreview, image: UIImage)
}

class ImagePreview: UIView {

    weak var delegate: ImagePreviewDelegate?
    
    init(image: UIImage, view: UIView, completion:() -> ())
    {
        super.init(frame: UIScreen.mainScreen().bounds)
        
    }
    
    func imagePreviewCompletionHandler()
    {
        //
    }
    
    func previewImage() -> Void
    {
        //
    }
}

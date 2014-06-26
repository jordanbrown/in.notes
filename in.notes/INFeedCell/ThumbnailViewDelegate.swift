//
//  ThumbnailViewDelegate.swift
//  in.notes
//
//  Created by Michael Babiy on 6/25/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

/**
*  Dedicated protocol for managing thumbnail selection in each
*  table view cell. Each view controller interested in being
*  notified what thumbnail (index) was selected, must implement
*  this protocol. Index path is calculated the following way:

*  1. Get location in view from TapGesture.
*  2. Get index path from indexPathForRowAtPoint: method.
*  3. Get an object from fetchedResultsController using above index path.
*/

import Foundation

@objc protocol ThumbnailViewDelegate
{
    /**
    *  Protocol method for returning selected thumbnail and
    *  tapGestureRecognizer for
    *
    *  @param thumbnail            being selected by the user.
    *  @param tapGestureRecognizer being fired by the system.
    */
    
    func thumbnail(thumbnail: UIImageView, didSelectThumbnailImageView tapGestureRecognizer: UITapGestureRecognizer)
}

//
//  INThumbnailViewProtocol.h
//  in.notes
//
//  Created by iC on 5/5/14.
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

#import <Foundation/Foundation.h>

@protocol INThumbnailViewDelegate <NSObject>

/**
 *  Protocol method for returning selected thumbnail and
 *  tapGestureRecognizer for
 *
 *  @param thumbnail            being selected by the user.
 *  @param tapGestureRecognizer being fired by the system.
 */
- (void)thumbnail:(UIImageView *)thumbnail didSelectThumbnailImageView:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

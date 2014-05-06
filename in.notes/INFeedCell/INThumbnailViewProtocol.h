//
//  INThumbnailViewProtocol.h
//  in.notes
//
//  Created by iC on 5/5/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INThumbnailViewDelegate <NSObject>

- (void)thumbnail:(UIImageView *)thumbnail didSelectThumbnailImageView:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

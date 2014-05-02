//
//  UIImage+MCResize.h
//  macciTi
//
//  Created by iC on 4/28/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MCResize)

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
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size cornerRadius:(float)cornerRadius;

@end

//
//  UIImage+MCResize.m
//  macciTi
//
//  Created by iC on 4/28/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "UIImage+MCResize.h"

@implementation UIImage (MCResize)

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size cornerRadius:(float)cornerRadius
{
    CGSize originalImageSize = [image size];
    CGRect newRect = CGRectMake(0.0f, 0.0f, size.width, size.height); // The rectangle of the new image.
    float ratio = MAX(newRect.size.width / originalImageSize.width, newRect.size.height / originalImageSize.height); // Figure out scaling ratio.
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0f); // Creating transperant bitmap context with scaling factor equal to that of the screen.
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:cornerRadius];
    [path addClip];
    
    CGRect projectRect; // Center the image in the thumbnail rectangle.
    projectRect.size.width = ratio * originalImageSize.width;
    projectRect.size.height = ratio * originalImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    return UIGraphicsGetImageFromCurrentImageContext(); // Get the image from context.
}

@end

//
//  INPlaceholderView.m
//  in.notes
//
//  Created by iC on 5/7/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INPlaceholderView.h"

@implementation INPlaceholderView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame image:nil];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]];
        [self setAlpha:0.0];
        
        CGRect imageViewFrame = {
            .origin.x = frame.size.width / 2 - image.size.width / 2,
            .origin.y = frame.size.height / 2 - image.size.height / 2 - 64.0, // 64 is the height of the navigation bar. Perhaps refactor for auto check?
            .size.width = image.size.width,
            .size.height = image.size.height
        };
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageViewFrame];
        imageView.image = image;
        imageView.alpha = 0.2;
        
        [self addSubview:imageView];
        [self animateAlpha];
        
    }
    return self;
}

- (void)animateAlpha
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         self.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                             
                             //
                             
                         }
                     }];
}

//- (void)drawRect:(CGRect)rect
//{
//    //// Color Declarations
//    UIColor* color0 = [UIColor colorWithRed:0.44 green:0.51 blue:0.6 alpha:1];
//    
//    //// Bezier Drawing
//    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint: CGPointMake(76, 13.68)];
//    [bezierPath addLineToPoint: CGPointMake(26.93, 13.68)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 19.46) controlPoint1: CGPointMake(23.74, 13.68) controlPoint2: CGPointMake(21.15, 16.28)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 24.03)];
//    [bezierPath addCurveToPoint: CGPointMake(18.22, 27.23) controlPoint1: CGPointMake(19.51, 24.19) controlPoint2: CGPointMake(18.22, 25.56)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 30.44) controlPoint1: CGPointMake(18.22, 28.91) controlPoint2: CGPointMake(19.51, 30.28)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 34.11)];
//    [bezierPath addCurveToPoint: CGPointMake(18.22, 37.31) controlPoint1: CGPointMake(19.51, 34.27) controlPoint2: CGPointMake(18.22, 35.63)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 40.51) controlPoint1: CGPointMake(18.22, 38.99) controlPoint2: CGPointMake(19.51, 40.35)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 44.43)];
//    [bezierPath addCurveToPoint: CGPointMake(18.22, 47.63) controlPoint1: CGPointMake(19.51, 44.58) controlPoint2: CGPointMake(18.22, 45.95)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 50.83) controlPoint1: CGPointMake(18.22, 49.3) controlPoint2: CGPointMake(19.51, 50.67)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 54.5)];
//    [bezierPath addCurveToPoint: CGPointMake(18.22, 57.7) controlPoint1: CGPointMake(19.51, 54.66) controlPoint2: CGPointMake(18.22, 56.03)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 60.91) controlPoint1: CGPointMake(18.22, 59.38) controlPoint2: CGPointMake(19.51, 60.75)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 64.53)];
//    [bezierPath addCurveToPoint: CGPointMake(18.22, 67.73) controlPoint1: CGPointMake(19.51, 64.69) controlPoint2: CGPointMake(18.22, 66.06)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 70.93) controlPoint1: CGPointMake(18.22, 69.41) controlPoint2: CGPointMake(19.51, 70.78)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 80.54)];
//    [bezierPath addCurveToPoint: CGPointMake(26.93, 86.32) controlPoint1: CGPointMake(21.15, 83.73) controlPoint2: CGPointMake(23.74, 86.32)];
//    [bezierPath addLineToPoint: CGPointMake(76, 86.32)];
//    [bezierPath addCurveToPoint: CGPointMake(81.78, 80.54) controlPoint1: CGPointMake(79.19, 86.32) controlPoint2: CGPointMake(81.78, 83.72)];
//    [bezierPath addLineToPoint: CGPointMake(81.78, 19.46)];
//    [bezierPath addCurveToPoint: CGPointMake(76, 13.68) controlPoint1: CGPointMake(81.78, 16.28) controlPoint2: CGPointMake(79.19, 13.68)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(21.15, 69.28)];
//    [bezierPath addCurveToPoint: CGPointMake(19.87, 67.73) controlPoint1: CGPointMake(20.42, 69.14) controlPoint2: CGPointMake(19.87, 68.5)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 66.18) controlPoint1: CGPointMake(19.87, 66.96) controlPoint2: CGPointMake(20.42, 66.32)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 69.28)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(21.15, 59.25)];
//    [bezierPath addCurveToPoint: CGPointMake(19.87, 57.7) controlPoint1: CGPointMake(20.42, 59.11) controlPoint2: CGPointMake(19.87, 58.47)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 56.15) controlPoint1: CGPointMake(19.87, 56.94) controlPoint2: CGPointMake(20.42, 56.3)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 59.25)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(21.15, 49.18)];
//    [bezierPath addCurveToPoint: CGPointMake(19.87, 47.63) controlPoint1: CGPointMake(20.42, 49.03) controlPoint2: CGPointMake(19.87, 48.39)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 46.08) controlPoint1: CGPointMake(19.87, 46.86) controlPoint2: CGPointMake(20.42, 46.22)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 49.18)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(21.15, 38.86)];
//    [bezierPath addCurveToPoint: CGPointMake(19.87, 37.31) controlPoint1: CGPointMake(20.42, 38.72) controlPoint2: CGPointMake(19.87, 38.08)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 35.76) controlPoint1: CGPointMake(19.87, 36.54) controlPoint2: CGPointMake(20.42, 35.9)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 38.86)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(21.15, 28.78)];
//    [bezierPath addCurveToPoint: CGPointMake(19.87, 27.23) controlPoint1: CGPointMake(20.42, 28.64) controlPoint2: CGPointMake(19.87, 28)];
//    [bezierPath addCurveToPoint: CGPointMake(21.15, 25.68) controlPoint1: CGPointMake(19.87, 26.47) controlPoint2: CGPointMake(20.42, 25.83)];
//    [bezierPath addLineToPoint: CGPointMake(21.15, 28.78)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(78.47, 80.54)];
//    [bezierPath addCurveToPoint: CGPointMake(76, 83.02) controlPoint1: CGPointMake(78.47, 81.9) controlPoint2: CGPointMake(77.36, 83.02)];
//    [bezierPath addLineToPoint: CGPointMake(26.93, 83.02)];
//    [bezierPath addCurveToPoint: CGPointMake(24.45, 80.54) controlPoint1: CGPointMake(25.56, 83.02) controlPoint2: CGPointMake(24.45, 81.9)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 70.96)];
//    [bezierPath addLineToPoint: CGPointMake(26.9, 70.96)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 72.88) controlPoint1: CGPointMake(27.18, 72.07) controlPoint2: CGPointMake(28.17, 72.88)];
//    [bezierPath addCurveToPoint: CGPointMake(31.93, 70.32) controlPoint1: CGPointMake(30.78, 72.88) controlPoint2: CGPointMake(31.93, 71.74)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 67.76) controlPoint1: CGPointMake(31.93, 68.91) controlPoint2: CGPointMake(30.78, 67.76)];
//    [bezierPath addCurveToPoint: CGPointMake(27.02, 69.31) controlPoint1: CGPointMake(28.31, 67.76) controlPoint2: CGPointMake(27.41, 68.4)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 69.31)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 60.94)];
//    [bezierPath addLineToPoint: CGPointMake(26.9, 60.94)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 62.86) controlPoint1: CGPointMake(27.18, 62.04) controlPoint2: CGPointMake(28.17, 62.86)];
//    [bezierPath addCurveToPoint: CGPointMake(31.93, 60.3) controlPoint1: CGPointMake(30.78, 62.86) controlPoint2: CGPointMake(31.93, 61.71)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 57.74) controlPoint1: CGPointMake(31.93, 58.88) controlPoint2: CGPointMake(30.78, 57.74)];
//    [bezierPath addCurveToPoint: CGPointMake(27.02, 59.28) controlPoint1: CGPointMake(28.31, 57.74) controlPoint2: CGPointMake(27.41, 58.37)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 59.28)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 50.86)];
//    [bezierPath addLineToPoint: CGPointMake(26.97, 50.86)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 52.54) controlPoint1: CGPointMake(27.33, 51.84) controlPoint2: CGPointMake(28.26, 52.54)];
//    [bezierPath addCurveToPoint: CGPointMake(31.93, 49.98) controlPoint1: CGPointMake(30.78, 52.54) controlPoint2: CGPointMake(31.93, 51.39)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 47.42) controlPoint1: CGPointMake(31.93, 48.57) controlPoint2: CGPointMake(30.78, 47.42)];
//    [bezierPath addCurveToPoint: CGPointMake(26.94, 49.21) controlPoint1: CGPointMake(28.22, 47.42) controlPoint2: CGPointMake(27.27, 48.17)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 49.21)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 40.54)];
//    [bezierPath addLineToPoint: CGPointMake(26.91, 40.54)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 42.43) controlPoint1: CGPointMake(27.2, 41.63) controlPoint2: CGPointMake(28.19, 42.43)];
//    [bezierPath addCurveToPoint: CGPointMake(31.93, 39.87) controlPoint1: CGPointMake(30.78, 42.43) controlPoint2: CGPointMake(31.93, 41.28)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 37.31) controlPoint1: CGPointMake(31.93, 38.46) controlPoint2: CGPointMake(30.78, 37.31)];
//    [bezierPath addCurveToPoint: CGPointMake(27, 38.89) controlPoint1: CGPointMake(28.3, 37.31) controlPoint2: CGPointMake(27.39, 37.96)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 38.89)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 30.47)];
//    [bezierPath addLineToPoint: CGPointMake(26.84, 30.47)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 32.73) controlPoint1: CGPointMake(26.98, 31.74) controlPoint2: CGPointMake(28.05, 32.73)];
//    [bezierPath addCurveToPoint: CGPointMake(31.93, 30.17) controlPoint1: CGPointMake(30.78, 32.73) controlPoint2: CGPointMake(31.93, 31.59)];
//    [bezierPath addCurveToPoint: CGPointMake(29.37, 27.61) controlPoint1: CGPointMake(31.93, 28.76) controlPoint2: CGPointMake(30.78, 27.61)];
//    [bezierPath addCurveToPoint: CGPointMake(27.2, 28.81) controlPoint1: CGPointMake(28.45, 27.61) controlPoint2: CGPointMake(27.66, 28.09)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 28.81)];
//    [bezierPath addLineToPoint: CGPointMake(24.45, 19.46)];
//    [bezierPath addCurveToPoint: CGPointMake(26.92, 16.98) controlPoint1: CGPointMake(24.45, 18.1) controlPoint2: CGPointMake(25.56, 16.98)];
//    [bezierPath addLineToPoint: CGPointMake(76, 16.98)];
//    [bezierPath addCurveToPoint: CGPointMake(78.47, 19.46) controlPoint1: CGPointMake(77.36, 16.98) controlPoint2: CGPointMake(78.47, 18.1)];
//    [bezierPath addLineToPoint: CGPointMake(78.47, 80.54)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(72.23, 28.54)];
//    [bezierPath addCurveToPoint: CGPointMake(71, 29.78) controlPoint1: CGPointMake(72.23, 29.22) controlPoint2: CGPointMake(71.68, 29.78)];
//    [bezierPath addLineToPoint: CGPointMake(38.53, 29.78)];
//    [bezierPath addCurveToPoint: CGPointMake(37.29, 28.54) controlPoint1: CGPointMake(37.85, 29.78) controlPoint2: CGPointMake(37.29, 29.22)];
//    [bezierPath addCurveToPoint: CGPointMake(38.53, 27.3) controlPoint1: CGPointMake(37.29, 27.86) controlPoint2: CGPointMake(37.85, 27.3)];
//    [bezierPath addLineToPoint: CGPointMake(71, 27.3)];
//    [bezierPath addCurveToPoint: CGPointMake(72.23, 28.54) controlPoint1: CGPointMake(71.68, 27.3) controlPoint2: CGPointMake(72.23, 27.86)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(68.25, 38.58)];
//    [bezierPath addCurveToPoint: CGPointMake(67.01, 39.82) controlPoint1: CGPointMake(68.25, 39.27) controlPoint2: CGPointMake(67.69, 39.82)];
//    [bezierPath addLineToPoint: CGPointMake(42.52, 39.82)];
//    [bezierPath addCurveToPoint: CGPointMake(41.28, 38.58) controlPoint1: CGPointMake(41.84, 39.82) controlPoint2: CGPointMake(41.28, 39.27)];
//    [bezierPath addCurveToPoint: CGPointMake(42.52, 37.34) controlPoint1: CGPointMake(41.28, 37.9) controlPoint2: CGPointMake(41.84, 37.34)];
//    [bezierPath addLineToPoint: CGPointMake(67.01, 37.34)];
//    [bezierPath addCurveToPoint: CGPointMake(68.25, 38.58) controlPoint1: CGPointMake(67.69, 37.34) controlPoint2: CGPointMake(68.25, 37.9)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(68.25, 48.76)];
//    [bezierPath addCurveToPoint: CGPointMake(67.01, 50) controlPoint1: CGPointMake(68.25, 49.45) controlPoint2: CGPointMake(67.69, 50)];
//    [bezierPath addLineToPoint: CGPointMake(42.52, 50)];
//    [bezierPath addCurveToPoint: CGPointMake(41.28, 48.76) controlPoint1: CGPointMake(41.84, 50) controlPoint2: CGPointMake(41.28, 49.45)];
//    [bezierPath addCurveToPoint: CGPointMake(42.52, 47.52) controlPoint1: CGPointMake(41.28, 48.08) controlPoint2: CGPointMake(41.84, 47.52)];
//    [bezierPath addLineToPoint: CGPointMake(67.01, 47.52)];
//    [bezierPath addCurveToPoint: CGPointMake(68.25, 48.76) controlPoint1: CGPointMake(67.69, 47.52) controlPoint2: CGPointMake(68.25, 48.08)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(68.25, 58.67)];
//    [bezierPath addCurveToPoint: CGPointMake(67.01, 59.91) controlPoint1: CGPointMake(68.25, 59.35) controlPoint2: CGPointMake(67.69, 59.91)];
//    [bezierPath addLineToPoint: CGPointMake(42.52, 59.91)];
//    [bezierPath addCurveToPoint: CGPointMake(41.28, 58.67) controlPoint1: CGPointMake(41.84, 59.91) controlPoint2: CGPointMake(41.28, 59.35)];
//    [bezierPath addCurveToPoint: CGPointMake(42.52, 57.43) controlPoint1: CGPointMake(41.28, 57.98) controlPoint2: CGPointMake(41.84, 57.43)];
//    [bezierPath addLineToPoint: CGPointMake(67.01, 57.43)];
//    [bezierPath addCurveToPoint: CGPointMake(68.25, 58.67) controlPoint1: CGPointMake(67.69, 57.43) controlPoint2: CGPointMake(68.25, 57.98)];
//    [bezierPath closePath];
//    [bezierPath moveToPoint: CGPointMake(68.25, 69.19)];
//    [bezierPath addCurveToPoint: CGPointMake(67.01, 70.43) controlPoint1: CGPointMake(68.25, 69.87) controlPoint2: CGPointMake(67.69, 70.43)];
//    [bezierPath addLineToPoint: CGPointMake(42.52, 70.43)];
//    [bezierPath addCurveToPoint: CGPointMake(41.28, 69.19) controlPoint1: CGPointMake(41.84, 70.43) controlPoint2: CGPointMake(41.28, 69.87)];
//    [bezierPath addCurveToPoint: CGPointMake(42.52, 67.95) controlPoint1: CGPointMake(41.28, 68.51) controlPoint2: CGPointMake(41.84, 67.95)];
//    [bezierPath addLineToPoint: CGPointMake(67.01, 67.95)];
//    [bezierPath addCurveToPoint: CGPointMake(68.25, 69.19) controlPoint1: CGPointMake(67.69, 67.95) controlPoint2: CGPointMake(68.25, 68.51)];
//    [bezierPath closePath];
//    bezierPath.miterLimit = 4;
//    
//    [[UIColor blackColor] setFill];
//    [bezierPath fill];
//}

@end

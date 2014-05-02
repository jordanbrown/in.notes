//
//  ProgressView.h
//  testdel
//
//  Created by Paolo Boschini on 8/8/13. 
//  Copyright (c) 2013 Paolo Boschini. All rights reserved.
//

typedef enum : NSUInteger {
    
    kMCViewTypeImageThumbnailView = 0,
    kMCViewTypeFullView =1,
    
} kMCViewType;

#import <UIKit/UIKit.h>

@interface SProgressHUD : UIView

@property BOOL animating;
@property (nonatomic) float radius;

- (id)initWithFrame:(CGRect)frame withPointDiameter:(int)diameter withInterval:(float)interval;
- (instancetype)initForViewType:(kMCViewType)viewType;

@end

//
//  INQuotes.h
//  in.notes
//
//  Created by iC on 5/4/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INQuotes : NSObject

+ (instancetype)sharedQuotes;
- (NSString *)quote;

@end

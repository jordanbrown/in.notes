//
//  INQuotes.m
//  in.notes
//
//  Created by iC on 5/4/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INQuotes.h"

@implementation INQuotes

+ (instancetype)sharedQuotes
{
    static INQuotes *sharedQuotes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuotes = [[INQuotes alloc]init];
    });
    
    return sharedQuotes;
}

- (NSString *)quote
{
    NSString *quotesFile = [[NSBundle mainBundle]pathForResource:@"quotes" ofType:@"plist"];
    NSArray *quotes = [[NSArray alloc]initWithContentsOfFile:quotesFile];
    NSUInteger randomQuoteIndex = arc4random() % [quotes count];
    return [quotes objectAtIndex:randomQuoteIndex];
}

@end

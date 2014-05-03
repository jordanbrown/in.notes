//
//  INHashtagContainer.m
//  in.notes
//
//  Created by iC on 4/11/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

// TO DO: Make sure hashtags only contain words, no special characters. 

#import "INHashtagContainer.h"

static NSString * const kINHashtagSearchPattern = @"(#[A-Za-z0-9]+)";

@implementation INHashtagContainer

+ (NSArray *)hashtagArrayFromString:(NSString *)string
{
    NSMutableArray *hashtags = [[NSMutableArray alloc]init];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kINHashtagSearchPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (!error) {
        [regex enumerateMatchesInString:string
                                options:0
                                  range:NSMakeRange(0, [string length])
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 if ([string substringWithRange:result.range]) {
                                     [hashtags addObject:[string substringWithRange:result.range]];
                                 }
                             }];
    }
    return hashtags;
}

+ (NSString *)hashtagStringFromString:(NSString *)string
{
    __block NSString *hashtags = [[NSString alloc]init];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kINHashtagSearchPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (!error) {
        [regex enumerateMatchesInString:string
                                options:0
                                  range:NSMakeRange(0, [string length])
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 if ([string substringWithRange:result.range]) {
                                     hashtags = [hashtags stringByAppendingString:[string substringWithRange:result.range]];
                                 }
                             }];
    }
    return hashtags;
}

+ (NSData *)hashtagDataFromString:(NSString *)string
{
    if ([[INHashtagContainer hashtagArrayFromString:string]count] > 0) {
        return [NSKeyedArchiver archivedDataWithRootObject:[INHashtagContainer hashtagArrayFromString:string]];
    } else {
        return [NSData data];
    }
}

@end

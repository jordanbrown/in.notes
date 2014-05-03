//
//  INHashtagContainer.h
//  in.notes
//
//  Created by iC on 4/11/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INHashtagContainer : NSObject

/**
 *  Methods for analyzing the string for hashtag.
 *
 *  @param string to be analyzed.
 *
 *  @return NSArray of hashtag strings.
 *  @return NSString of hashtags combined into a single string.
 
 *  If search doesnt return anything, hashtagArrayFromString: will return valid but empty array.
 *  If search doesnt return anything, hashtagStringFromString: will return valid but empty string.
 
 */
+ (NSArray *)hashtagArrayFromString:(NSString *)string;
+ (NSString *)hashtagStringFromString:(NSString *)string;

/**
 *  Method for creting NSData by archiving the array of hashtags.
 *  Behind the scenes, this method calls hashtagArrayFromString: to convert
 *  the text into an array of hashtags. If successful, it then archives the 
 *  the array and returns NSData. This method also makes sure if the hashtag array, if empty,
 *  will return an empty NSData object to safeguard from crash down the road.
 *
 *  @param string to be analyzed.
 *
 *  @return NSData of hashtags that later can be converted into an array. 
 */
+ (NSData *)hashtagDataFromString:(NSString *)string;

@end

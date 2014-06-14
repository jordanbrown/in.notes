//
//  HashtagContainer.swift
//  in.notes
//
//  Created by Michael Babiy on 6/14/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

let kINHashtagSearchPattern: String = "(#[A-Za-z0-9]+)"

@objc class HashtagContainer: NSObject {
    
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
    class func hashtagArrayFromString(string: String) -> Array <String>
    {
        var hashtags: Array <String> = Array()
        var error: NSError?
        
        let regex: NSRegularExpression = NSRegularExpression.regularExpressionWithPattern(kINHashtagSearchPattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
        
        if !error {
            regex.enumerateMatchesInString(string, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, countElements(string)), usingBlock: {
                result, flags, stop in
                if result {
                    hashtags += (string.bridgeToObjectiveC().substringWithRange(result!.range))
                }
            })
        }
        return hashtags
    }
    
    class func hashtagStringFromString(string: String) -> String
    {
        var hashtags: String = String()
        var error: NSError?
        let regex: NSRegularExpression = NSRegularExpression.regularExpressionWithPattern(kINHashtagSearchPattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
        
        if !error {
            regex.enumerateMatchesInString(string, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, countElements(string)), usingBlock: {
                result, flags, stop in
                if result {
                    let range: NSRange = result!.range
                    let hashtag: String = string.bridgeToObjectiveC().substringWithRange(range)
                    hashtags = hashtags.stringByAppendingString(hashtag)
                }
            })
        }
        return hashtags
    }
    
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
    class func hashtagDataFromString(string: String) -> NSData
    {
        if (HashtagContainer.hashtagArrayFromString(string).count > 0) {
            return NSKeyedArchiver.archivedDataWithRootObject(HashtagContainer.hashtagArrayFromString(string))
        } else {
            return NSData()
        }
    }
}

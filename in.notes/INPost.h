//
//  INPost.h
//  in.notes
//
//  Created by iC on 5/4/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface INPost : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSData * hashtags;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * type;

@end

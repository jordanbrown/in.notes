//
//  MCImageStore.m
//  macciTi
//
//  Created by iC on 3/20/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCImageStore.h"

@implementation MCImageStore

+ (instancetype)sharedStore
{
    static MCImageStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc]init];
    });
    return sharedStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _store = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [self.store setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key
{
    return [self.store objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (key) {
        [self.store removeObjectForKey:key];
    }
}

- (void)deleteStore
{
    [self.store removeAllObjects];
}

- (NSData *)imageDataForCurrentImage
{
    return UIImageJPEGRepresentation([self imageForKey:kMCImageStoreKey], IN_IMAGE_STORE_DEFAULT_JPG_QUALITY);
}

- (NSData *)imageDataForImage:(UIImage *)image
{
    return UIImageJPEGRepresentation(image, IN_IMAGE_STORE_DEFAULT_JPG_QUALITY);
}

- (NSString *)imageName
{
    return [[NSUUID UUID]UUIDString];
}

@end

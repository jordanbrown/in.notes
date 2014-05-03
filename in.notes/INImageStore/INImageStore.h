//
//  INImageStore.h
//  in.notes
//
//  Created by iC on 3/20/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kINImageStoreKey = @"imageStoreKey";

@interface INImageStore : NSObject

@property (strong, nonatomic) NSMutableDictionary *store;

/**
 *  Singleton for storing "last" image selected by the user in the applicatioin sandbox.
 *
 *  @return instance of the INImageStore.
 */

+ (instancetype)sharedStore;

/**
 *  Method for setting and getting currently selected image from the Documents directory.
 *
 *  @param image to be saved.
 *  @param key   used for naming the image for store. As it stands, I am using a constant
 *  because there is no reason the keep more than one file.
 */
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;

/**
 *  Method for removing image(s) from the Documents directory.
 *
 *  @param key is the name of the image to be removed.
 */
- (void)deleteImageForKey:(NSString *)key;

/**
 *  Convenience method for returning NSData for currently saved image.
 *
 *  @return UIImageJPEGRepresentation @ quality of 0.8. If decide to actually 
 *  store more images in the direcotry, this wont work. Something like imageDataForImageForKey: will do.
 */
- (NSData *)imageDataForCurrentImage;
- (NSData *)imageDataForImage:(UIImage *)image;

/**
 *  This method is completely optional, as in, its not needed at for working with current INImageStore.
 *  It is relevant only if using Parse. So instead of calling [PFFile fileWithData:] and have the server 
 *  generate the name for the file, I generate it myself. I assume its faster? waiting on the server to generate
 *  a UUID might be unnoticable, but it is still faster on phone.
 *
 *  @return UUID string.
 */
- (NSString *)imageName;


@end

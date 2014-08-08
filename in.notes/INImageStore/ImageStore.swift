//
//  ImageStore.swift
//  in.notes
//
//  Created by Michael Babiy on 6/14/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

let kINImageKey = "imageStoreKey"
let kIMageStoreDefaultJPGQuality: CGFloat = 0.7

@objc class ImageStore: NSObject {
    
    var store = Dictionary <String, UIImage?>()
    
    /**
    *  Singleton for storing "last" image selected by the user in the applicatioin sandbox.
    *
    *  @return instance of the INImageStore.
    */
    class func sharedStore() -> ImageStore {
    struct Static {
        static let instance : ImageStore = ImageStore()
        }
        return Static.instance
    }
    
    /**
    *  Method for setting and getting currently selected image from the Documents directory.
    *
    *  @param image to be saved.
    *  @param key   used for naming the image for store. As it stands, I am using a constant
    *  because there is no reason the keep more than one file.
    */
    func setImage(image: UIImage, forKey key:String) -> Void {
        store[key] = image
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let image = store[key] {
            return image
        } else {
            return nil
        }
    }
    
    /**
    *  Method for removing image(s) from the Documents directory.
    *
    *  @param key is the name of the image to be removed.
    */
    func deleteImageForKey(key: String) -> Void {
        store.updateValue(nil, forKey: key)
    }
    
    /**
    *  Convenience method for returning NSData for currently saved image.
    *
    *  @return UIImageJPEGRepresentation @ quality of 0.8. If decide to actually
    *  store more images in the direcotry, this wont work. Something like imageDataForImageForKey: will do.
    */
    func imageDataForCurrentImage() -> NSData {
        return UIImageJPEGRepresentation(imageForKey(kINImageKey), kIMageStoreDefaultJPGQuality)
    }
    
    func imageDataForImage(image: UIImage) -> NSData {
        return UIImageJPEGRepresentation(image, kIMageStoreDefaultJPGQuality)
    }
    
    /**
    *  This method is completely optional, as in, its not needed at for working with current INImageStore.
    *  It is relevant only if using Parse. So instead of calling [PFFile fileWithData:] and have the server
    *  generate the name for the file, I generate it myself. I assume its faster? waiting on the server to generate
    *  a UUID might be unnoticable, but it is still faster on phone.
    *
    *  @return UUID string.
    */
    func imageName() -> String {
        return NSUUID.UUID().UUIDString
    }
}

let _sharedStore = ImageStore()



//
//  ImageStore.swift
//  LootLogger
//
//  Created by Riccardo Carlotto on 27/07/2021.
//

import UIKit

class ImageStore {
    
    let cache = NSCache<NSString,UIImage>()
    // cache works like a dictionary and also it automatically removes objects if the system gets low on memory.
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        //create a full url for the image with the name of the image itself that will be the key
        let url = imageURL(forKey: key)
        
        //turn image into jpeg data
        if let data = image.jpegData(compressionQuality: 0.5) {
            //write the full url
            try? data.write(to: url)
        }
        
    }
    
    func image(forKey key: String) ->UIImage? {
        
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print ("Error removing the image from disk \(error)")
        }
    }
    
    
    // this func below get the url of th document folder in the app and append (add if you will) in the url a string that is the key, that's it. it sort of create an url of that does't exist yet and it's the way to name the photo I will save through setImage(image:, key:)
    func imageURL(forKey key: String) -> URL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
}

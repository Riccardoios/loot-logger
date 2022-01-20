//
//  ImageStore.swift
//  LootLogger
//
//  Created by Riccardo Carlotto on 27/07/2021.
//

import UIKit
import AVFoundation

class VideoStore {
    
    let cache = NSCache<NSString, NSData>()
    // cache works like a dictionary and also it automatically removes objects if the system gets low on memory.
    
    func setVideo(_ video: NSData, forKey key: String) {
        cache.setObject(video, forKey: key as NSString)
        
        //create a full url for the image with the name of the image itself that will be the key
        let url = videoURL(forKey: key)
        
        video.write(toFile: url.absoluteString, atomically: false)
       
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
    func videoURL(forKey key: String) -> URL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
}

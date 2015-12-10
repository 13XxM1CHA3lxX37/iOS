//
//  ImageDownloader.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class ImageDownloader {
    
    static var imageCache = [String:UIImage]()
    
    init(url: String) {
        getImage(url)
    }
    
    init() {}
    
    var request: Request?
    
    var image: UIImage?
 
    var subscribersToImage = [ImageDownloadSubscriber]()
    
    func notifySubscribers() {
        for s in self.subscribersToImage {
            s.updateImageView()
        }
    }
    
    func subscribeToImage(subscriber: ImageDownloadSubscriber) {
        subscribersToImage.append(subscriber)
    }
    
    func clearSubscribers() {
        subscribersToImage.removeAll()
        request?.cancel()
    }
    
    func getImage(urlString: String) {
        if let cachedImage = ImageDownloader.imageCache[urlString] {
            self.image = cachedImage
            notifySubscribers()
        } else {
            request = Alamofire.request(.GET, urlString).validate().responseData() { (response) in
                if let data = response.result.value, imageFromData = UIImage(data: data) {
                    ImageDownloader.imageCache[urlString] = imageFromData
                    self.image = imageFromData
                    self.notifySubscribers()
                }
            }
        }
    }
    
}
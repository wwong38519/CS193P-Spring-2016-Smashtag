//
//  ImageCollectionViewCell.swift
//  Smashtag
//
//  Created by Winnie on 22/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView! { didSet { updateUI() } }
    
    var tweetMedia: (Twitter.Tweet, Twitter.MediaItem)? {
        didSet {
            if let (_, media) = tweetMedia {
                url = media.url
            }
        }
    }
    
    var url: NSURL? { didSet { updateUI() } }
    
    private func updateUI() {
        if let imageUrl = url {
            fetchImage(imageUrl)
        }
    }
    
    private func fetchImage(url: NSURL) {
        if let image = ImageCache.get(url) {
            imageView.image = image
        } else {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                let data = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) { [weak weakSelf = self] in
                    if let imageData = data where url == self.url {
                        let image = UIImage(data: imageData)
                        weakSelf?.imageView.image = image
                        ImageCache.add(url, value: image!)
                    }
                }
            }
        }
    }
}

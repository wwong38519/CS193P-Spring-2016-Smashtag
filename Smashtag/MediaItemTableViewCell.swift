//
//  MediaItemTableViewCell.swift
//  Smashtag
//
//  Created by Winnie on 18/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class MediaItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView! { didSet { updateUI() } }
    
    @IBOutlet weak var spinner: UIImageView!
    
    var url: NSURL? { didSet { updateUI() } }

    private func updateUI() {
        if let imageUrl = url {
            fetchImage(imageUrl)
        }
    }
    
    private func fetchImage(url: NSURL) {
        if let image = ImageCache.get(url) {
            mediaImageView?.image = image
        } else {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                let data = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) { [weak weakSelf = self] in
                    if let imageData = data where url == self.url {
                        let image = UIImage(data: imageData)
                        weakSelf?.mediaImageView?.image = image
                        weakSelf?.spinner?.stopAnimating()
                        ImageCache.add(url, value: image!)
                    }
                }
            }
        }
    }
}

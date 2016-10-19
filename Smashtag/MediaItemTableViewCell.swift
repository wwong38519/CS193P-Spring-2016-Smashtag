//
//  MediaItemTableViewCell.swift
//  Smashtag
//
//  Created by Winnie on 18/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class MediaItemTableViewCell: UITableViewCell {

    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var mediaItem: MediaItem? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        if let mediaURL = mediaItem?.url {
            fetchImage(mediaURL)
        }
    }
    
    private func fetchImage(url: NSURL) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            let data = NSData(contentsOfURL: url)
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                if let imageData = data where url == self.mediaItem?.url {
                    self.mediaImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
}

//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            let text = NSMutableAttributedString(string: tweet.text)
            for hashtag in tweet.hashtags {
                text.addAttribute(NSForegroundColorAttributeName, value: TweetColor.hashtag, range: hashtag.nsrange)
            }
            for mention in tweet.userMentions {
                text.addAttribute(NSForegroundColorAttributeName, value: TweetColor.mention, range: mention.nsrange)
            }
            for url in tweet.urls {
                text.addAttribute(NSForegroundColorAttributeName, value: TweetColor.url, range: url.nsrange)
            }

            tweetTextLabel?.attributedText = text
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
//                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
//                    tweetProfileImageView?.image = UIImage(data: imageData)
//                }
                fetchImage(profileImageURL)
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }

    }
    
    private func fetchImage(url: NSURL) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            let data = NSData(contentsOfURL: url)
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                if let imageData = data where url == self.tweet?.user.profileImageURL {
                    self.tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
        }
    }
}

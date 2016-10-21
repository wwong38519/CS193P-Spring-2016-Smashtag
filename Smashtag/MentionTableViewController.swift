//
//  MentionTableViewController.swift
//  Smashtag
//
//  Created by Winnie on 15/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class MentionTableViewController: UITableViewController {
    
    var mentions = [MentionItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentions[section].itemObjects.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].itemType.rawValue
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if mentions[indexPath.section].itemType == .Media {
            if let media = mentions[indexPath.section].itemObjects[indexPath.row] as? MediaItem where media.aspectRatio != 0 {
                // aspectRatio = width / height
                return tableView.bounds.width / CGFloat(media.aspectRatio)
            }
        }
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section]
        switch mention.itemType {
        case .Media:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MediaItemCellIdentifier, forIndexPath: indexPath)
            if let mediaCell = cell as? MediaItemTableViewCell  {
                if let item = mention.itemObjects[indexPath.row] as? MediaItem {
                    mediaCell.url = item.url
                }
            }
            return cell
        case .Hashtags, .Users, .Urls:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MentionCellIdentifier, forIndexPath: indexPath)
            if let mentionCell = cell as? MentionTableViewCell {
                if let item = mention.itemObjects[indexPath.row] as? Mention {
                    mentionCell.labelText = item.keyword
                }
            }
            return cell
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationvc = segue.destinationViewController
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowSearchSegueIdentifier:
                if let tweetvc = destinationvc as? TweetTableViewController, mentionCell = sender as? MentionTableViewCell {
                    tweetvc.searchText = mentionCell.labelText
                }
            case Storyboard.ShowImageSegueIdentifier:
                if let imagevc = destinationvc as? ImageViewController, mediaItemCell = sender as? MediaItemTableViewCell {
                    imagevc.image = mediaItemCell.mediaImageView?.image
                }
            default:
                break
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.ShowSearchSegueIdentifier {
            if let cell = sender as? MentionTableViewCell, indexPath = tableView.indexPathForCell(cell)
                where mentions[indexPath.section].itemType == .Urls {
                if let cellUrl = cell.labelText, url = NSURL(string: cellUrl) {
                    UIApplication.sharedApplication().openURL(url)
                }
                return false
            }
        }
        return true
    }
}

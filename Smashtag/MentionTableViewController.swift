//
//  MentionTableViewController.swift
//  Smashtag
//
//  Created by Winnie on 15/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class MentionTableViewController: NaviagtionTableViewController {
    
    var mentions = [TweetMentions]() {
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
        return mentions[section].items.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].type.rawValue
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = mentions[indexPath.section].items[indexPath.row]
        if case let .Media(_, aspectRatio) = item where aspectRatio > 0 {
            return tableView.bounds.width / CGFloat(aspectRatio)
        }
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = mentions[indexPath.section].items[indexPath.row]
        switch item {
        case .Media(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MediaItemCellIdentifier, forIndexPath: indexPath)
            if let mediaCell = cell as? MediaItemTableViewCell  {
                mediaCell.url = url
            }
            return cell
        case .Hashtags,.Urls,.Users:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MentionCellIdentifier, forIndexPath: indexPath)
            if let mentionCell = cell as? MentionTableViewCell {
                if case let .Hashtags(text) = item {
                    mentionCell.labelText = text
                } else if case let .Urls(text) = item {
                    mentionCell.labelText = text
                } else if case let .Users(text) = item {
                    mentionCell.labelText = text
                }
            }
            return cell
        }
    }

    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            switch mentions[indexPath.section].type {
            case .Media:
                performSegueWithIdentifier(Storyboard.ShowImageSegueIdentifier, sender: cell)
            case .Hashtags, .Users:
                performSegueWithIdentifier(Storyboard.ShowSearchSegueIdentifier, sender: cell)
            case .Urls:
//                if let urlCell = cell as? MentionTableViewCell, url = NSURL(string: urlCell.labelText!) {
//                    UIApplication.sharedApplication().openURL(url)
//                }
                performSegueWithIdentifier(Storyboard.ShowWebSegueIdentifier, sender: cell)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationvc = segue.destinationViewController
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowSearchSegueIdentifier:
                if let tweetvc = destinationvc as? TweetTableViewController, mentionCell = sender as? MentionTableViewCell {
                    tweetvc.searchText = mentionCell.labelText
                }
            case Storyboard.ShowWebSegueIdentifier:
                if let webvc = destinationvc as? WebViewController, mentionCell = sender as? MentionTableViewCell {
                    webvc.url = NSURL(string: mentionCell.labelText!)
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
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if identifier == Storyboard.ShowSearchSegueIdentifier {
//            if let cell = sender as? MentionTableViewCell, indexPath = tableView.indexPathForCell(cell)
//                where mentions[indexPath.section].type == .Urls {
//                if let cellUrl = cell.labelText, url = NSURL(string: cellUrl) {
//                    UIApplication.sharedApplication().openURL(url)
//                }
//                return false
//            }
//        }
//        return true
//    }
}

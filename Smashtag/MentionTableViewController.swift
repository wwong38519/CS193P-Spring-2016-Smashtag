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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */
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
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section]
        switch mention.itemType {
        case .Media:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MediaItemCellIdentifier, forIndexPath: indexPath)
            if let mediaCell = cell as? MediaItemTableViewCell  {
                if let item = mention.itemObjects[indexPath.row] as? MediaItem {
                    mediaCell.mediaItem = item
                }
            }
            return cell
        case .Hashtags, .Users, .Urls:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MentionCellIdentifier, forIndexPath: indexPath)
            if let mentionCell = cell as? MentionTableViewCell {
                if let item = mention.itemObjects[indexPath.row] as? Mention {
                    mentionCell.mention = item
                    mentionCell.mentionType = mention.itemType
                }
            }
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationvc = segue.destinationViewController
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowSearchSegueIdentifier:
                if let tweetvc = destinationvc as? TweetTableViewController, mentionCell = sender as? MentionTableViewCell {
                    tweetvc.searchText = mentionCell.mention?.keyword
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
            if let cell = sender as? MentionTableViewCell where cell.mentionType == .Urls {
                if let cellUrl = cell.mention?.keyword, url = NSURL(string: cellUrl) {
                    UIApplication.sharedApplication().openURL(url)
                }
                return false
            }
        }
        return true
    }
}

public class MentionItem {
    let itemType: MentionType
    let itemObjects: [NSObject]
    
    init(type: MentionType, value: [NSObject]) {
        self.itemType = type
        self.itemObjects = value
    }
    
    enum MentionType: String {
        case Media, Hashtags, Users, Urls
    }
}

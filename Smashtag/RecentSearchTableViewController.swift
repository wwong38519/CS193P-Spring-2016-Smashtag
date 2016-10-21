//
//  RecentSearchTableViewController.swift
//  Smashtag
//
//  Created by Winnie on 20/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        title = Storyboard.RecentSearchTitle
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Truth.get()?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.RecentSearchCellIdentifier, forIndexPath: indexPath)
        if let list = Truth.get() {
            let item = list[indexPath.row]
            if let mentionCell = cell as? MentionTableViewCell {
                mentionCell.labelText = item
            }
        }
        return cell
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
            default:
                break
            }
        }
    }
}
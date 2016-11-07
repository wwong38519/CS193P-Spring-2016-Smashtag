//
//  RecentSearchTableViewController.swift
//  Smashtag
//
//  Created by Winnie on 20/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: NaviagtionTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Storyboard.ViewRecentSearchTitle
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Truth.get()?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.RecentSearchCellIdentifier, forIndexPath: indexPath)
        if let list = Truth.get() {
            cell.textLabel?.text = list[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MentionTableViewCell where editingStyle == .Delete {
            Truth.remove(cell.labelText!)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationvc = segue.destinationViewController
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowSearchSegueIdentifier:
                if let tweetvc = destinationvc as? TweetTableViewController, cell = sender as? UITableViewCell {
                    tweetvc.searchText = cell.textLabel?.text
                }
            case Storyboard.ShowPopularitySegueIdentifier:
                if let popularityvc = destinationvc as? PopularityTableViewController, cell = sender as? UITableViewCell {
                    popularityvc.searchText = cell.textLabel?.text
                }
            default:
                break
            }
        }
    }
}

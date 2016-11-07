//
//  PopularityTableViewController.swift
//  Smashtag
//
//  Created by Winnie on 31/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class PopularityTableViewController: CoreDataTableViewController {
    
    var searchText: String? { didSet { updateUI() } }
    
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    
    private func updateUI() {
        if let context = managedObjectContext where searchText != nil {
            let request = NSFetchRequest(entityName: CoreDataConstants.Mention)
            request.predicate = NSPredicate(format: "SUBQUERY(searchTerms, $s, $s.searchTerm = %@).@count > 0 AND count > 1", searchText!)
            request.sortDescriptors = [
                NSSortDescriptor(key: "count", ascending: false),
                NSSortDescriptor(key: "keyword", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            ]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        managedObjectContext = CoreDataUtils.context
        CoreDataUtils.printDatabaseStatistics()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.PopularityCellIdentifier, forIndexPath: indexPath)
        if let cdMention = fetchedResultsController?.objectAtIndexPath(indexPath) as? CDMention {
            cdMention.managedObjectContext?.performBlockAndWait{
                cell.textLabel?.text = cdMention.keyword
                cell.detailTextLabel?.text = String(cdMention.count ?? 0)
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
                if let tweetvc = destinationvc as? TweetTableViewController, cell = sender as? UITableViewCell {
                    tweetvc.searchText = cell.textLabel?.text
                }
            default:
                break
            }
        }
    }
}

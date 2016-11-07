//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: NaviagtionTableViewController, UITextFieldDelegate
{
    // MARK: Model

    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            navigationItem.title = searchText
            Truth.add(searchText!)
        }
    }
    
    // MARK: Fetching Tweets
    
    private var twitterRequest: Twitter.Request? {
        if lastTwitterRequest == nil {
            if var query = searchText where !query.isEmpty {
                if query[query.startIndex] == "@" {
                    query +=  " OR from:"+query.substringFromIndex(query.startIndex.advancedBy(1))
                }
                return Twitter.Request(search: query + " -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.requestForNewer
    }
    
    private var lastTwitterRequest: Twitter.Request?

    private func searchForTweets()
    {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                dispatch_async(dispatch_get_main_queue()) {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, atIndex: 0)
                            weakSelf?.updateDatabase(newTweets, searchTerm: weakSelf?.searchText)
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        searchForTweets()
    }
    
    // MARK: CoreData
    
    private var managedObjectContext = CoreDataUtils.context
    
    private func updateDatabase(tweets: [Twitter.Tweet], searchTerm: String?) {
        if let context = managedObjectContext {
            context.performBlock{
                let request = NSFetchRequest(entityName: CoreDataConstants.SearchTerm)
                request.predicate = NSPredicate(format: "searchTerm = %@", searchTerm!)

                var cdSearchTerm = (try? context.executeFetchRequest(request).first) as? CDSearchTerm
                if cdSearchTerm == nil {
                    cdSearchTerm = NSEntityDescription.insertNewObjectForEntityForName(CoreDataConstants.SearchTerm, inManagedObjectContext: context) as? CDSearchTerm
                    cdSearchTerm?.searchTerm = searchTerm
                }
                
                var ids = (cdSearchTerm?.tweets as? Set<CDTweet>).flatMap{ $0.flatMap{ $0.id } }
                let processTweets = ids == nil ? tweets : tweets.filter{ !ids!.contains($0.id) }

                for tweet in processTweets {
                    if let cdTweet = NSEntityDescription.insertNewObjectForEntityForName(CoreDataConstants.Tweet, inManagedObjectContext: context) as? CDTweet {
                        cdTweet.id = tweet.id
                        cdTweet.addToSearchTerms(cdSearchTerm!)
                        ids?.append(tweet.id)
                    }
                    
                    let mentions = tweet.hashtags.map{ ($0.keyword, MentionType.Hashtags) } + tweet.userMentions.map{ ($0.keyword, MentionType.Users) }
                    
                    for (keyword, type) in mentions {
                        if let cdMention = cdSearchTerm?.mentions?.filteredSetUsingPredicate(NSPredicate(format: "keyword = %@", keyword)).first as? CDMention {
                            cdMention.count += 1
                        } else {
                            if let cdMention = NSEntityDescription.insertNewObjectForEntityForName(CoreDataConstants.Mention, inManagedObjectContext: context) as? CDMention {
                                cdMention.keyword = keyword
                                cdMention.type = type.rawValue
                                cdMention.count = 1
                                cdMention.addToSearchTerms(cdSearchTerm!)
                            }
                        }
                    }
                }
//                try! context.save()
                CoreDataUtils.printDatabaseStatistics()
            }
        }
    }
    
    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
    
        return cell
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationvc = segue.destinationViewController
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowMentionSegueIdentifier:
                if let mentionvc = destinationvc as? MentionTableViewController {
                    if let tweetCell = sender as? TweetTableViewCell, tweet = tweetCell.tweet {
                        let screenName = "@"+tweet.user.screenName
                        if tweet.media.count > 0 {
                            mentionvc.mentions.append(TweetMentions(type: .Media, items: tweet.media.map { MentionItem.Media($0.url, $0.aspectRatio) }))
                        }
                        if tweet.hashtags.count > 0 {
                            mentionvc.mentions.append(TweetMentions(type: .Hashtags, items: tweet.hashtags.map { MentionItem.Hashtags($0.keyword) }))
                        }
                        var arr = tweet.userMentions.map { MentionItem.Users($0.keyword) }
                        arr.insert(MentionItem.Users(screenName), atIndex: 0)
                        mentionvc.mentions.append(TweetMentions(type: .Users, items: arr))
                        if tweet.urls.count > 0 {
                            mentionvc.mentions.append(TweetMentions(type: .Urls, items: tweet.urls.map { MentionItem.Urls($0.keyword) }))
                        }
                    }
                }
            case Storyboard.ShowImageCollectionSegueIdentifier:
                if let imagevc = destinationvc as? ImageCollectionViewController {
                    imagevc.searchText = searchTextField?.text
                }
            default:
                break
            }
        }
        
    }
}

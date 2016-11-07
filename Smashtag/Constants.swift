//
//  Constants.swift
//  Smashtag
//
//  Created by Winnie on 20/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Storyboard {
    // UITableViewCell
    static let TweetCellIdentifier = "Tweet"
    static let MentionCellIdentifier = "MentionCell"
    static let MediaItemCellIdentifier = "MediaItemCell"
    static let RecentSearchCellIdentifier = "MentionCell"
    static let ImageCollectionCellIdentifier = "ImageCell"
    static let PopularityCellIdentifier = "PopularityCell"
    // Segue
    static let ShowMentionSegueIdentifier = "Show Mention"
    static let ShowSearchSegueIdentifier = "Show Search"
    static let ShowWebSegueIdentifier = "Show Web"
    static let ShowImageSegueIdentifier = "Show Image"
    static let ShowImageCollectionSegueIdentifier = "Show Image Collection"
    static let ShowPopularitySegueIdentifier = "Show Popularity"
    // Navigation Controller Title
    static let ViewRecentSearchTitle = "Recent Search"
    
    static let RootButtonTitle = "Root"
    static let DoneButtonTitle = "Done"
    static let BackButtonTitle = "<"
    static let ForwardButtonTitle = ">"
}

struct TweetColor {
    static let hashtag = UIColor.grayColor()
    static let mention = UIColor.brownColor()
    static let url = UIColor.blueColor()
}

struct ImageZoom {  // Image View Controller
    static let MinScale: CGFloat = 0.5
    static let MaxScale: CGFloat = 2.0
}

public class Truth {
    private static let defaults = NSUserDefaults.standardUserDefaults()
    private static let size = 100
    private static let key = "TweetRecentSearch.Truth"
    
    class func get() -> [String]? {
        if let list = defaults.arrayForKey(key) as? [String] {
            return list
        } else {
            return nil
        }
    }
    
    class func add(item: String) {
        remove(item)
        var list = get() ?? [String]()
        if list.count > size {
            _ = list.removeLast()
        }
        list.insert(item, atIndex: 0)
        defaults.setObject(list, forKey: key)
    }
    
    class func remove(item: String) {
        if var list = get() {
            while let index = list.indexOf(item)  {
                list.removeAtIndex(index)
            }
            defaults.setObject(list, forKey: key)
        }
    }
}

public class ImageCache {
    
    private static let cache = NSCache()
    
    class func get(key: NSURL) -> UIImage? {
        return cache.objectForKey(key) as? UIImage ?? nil
    }
    
    class func add(key: NSURL, value: UIImage) {
        cache.setObject(value, forKey: key)
    }
}

public struct TweetMentions {
    let type: MentionType
    let items: [MentionItem]
    
    init(type: MentionType, items: [MentionItem]) {
        self.type = type
        self.items = items
    }
}

public enum MentionType: String {
    case Media, Hashtags, Users, Urls
}

public enum MentionItem {
    case Media(NSURL, Double)
    case Hashtags(String)
    case Users(String)
    case Urls (String)

    /* getting associated values not available in swift 2
    func associatedValue() -> Any {
        switch self {
        case .Media(let url, let aspectRatio):
            return (url, aspectRatio)
        case .Hashtags(let text):
            return text
        case .Users(let text):
            return text
        case .Urls(let text):
            return text
        }
    }
    */
}

struct CoreDataConstants {
    static let Model = "Model"
    static let Tweet = "CDTweet"
    static let Mention = "CDMention"
    static let SearchTerm = "CDSearchTerm"
}

public class CoreDataUtils {
    private static var _context: NSManagedObjectContext?
    static var context: NSManagedObjectContext?{
        get {
            if CoreDataUtils._context == nil {
                CoreDataUtils._context = CoreDataUtils.retrieveContext()
            }
            return CoreDataUtils._context
        }
    }
    private class func retrieveContext() -> NSManagedObjectContext? {
        let fm = NSFileManager.defaultManager()
        if let docsDir = fm.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
            let url = docsDir.URLByAppendingPathComponent(CoreDataConstants.Model)
            let document = UIManagedDocument(fileURL: url!)
            if document.documentState == .Normal {
                let context = document.managedObjectContext
                return context
            } else if document.documentState == .Closed {
                if let path = url?.path {
                    let fileExists = fm.fileExistsAtPath(path)
                    if fileExists {
                        document.openWithCompletionHandler(nil)
                    } else {
                        document.saveToURL(document.fileURL, forSaveOperation: .ForCreating, completionHandler: nil)
                    }
                    let context = document.managedObjectContext
                    return context
                }
            }
        }
        return nil
    }
    class func printDatabaseStatistics() {
        _context?.performBlock {
            if let results = try? self._context!.executeFetchRequest(NSFetchRequest(entityName: CoreDataConstants.Tweet)) {
                print("\(results.count) Tweets")
            }
            // a more efficient way to count objects ...
            let mentionCount = (try? self._context!.countForFetchRequest(NSFetchRequest(entityName: CoreDataConstants.Mention))) ?? 0
            print("\(mentionCount) Mentions")
            let searchTerm = (try? self._context!.countForFetchRequest(NSFetchRequest(entityName: CoreDataConstants.SearchTerm))) ?? 0
            print("\(searchTerm) Search Terms")
        }
    }
}

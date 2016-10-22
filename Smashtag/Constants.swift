//
//  Constants.swift
//  Smashtag
//
//  Created by Winnie on 20/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    // UITableViewCell
    static let TweetCellIdentifier = "Tweet"
    static let MentionCellIdentifier = "MentionCell"
    static let MediaItemCellIdentifier = "MediaItemCell"
    static let RecentSearchCellIdentifier = "MentionCell"
    // Segue
    static let ShowMentionSegueIdentifier = "Show Mention"
    static let ShowSearchSegueIdentifier = "Show Search"
    static let ShowWebSegueIdentifier = "Show Web"
    static let ShowImageSegueIdentifier = "Show Image"
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

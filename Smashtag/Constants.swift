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
    static let TweetCellIdentifier = "Tweet"
    static let MentionCellIdentifier = "MentionCell"
    static let MediaItemCellIdentifier = "MediaItemCell"
    static let RecentSearchCellIdentifier = "MentionCell"
    static let ShowMentionSegueIdentifier = "Show Mention"
    static let ShowSearchSegueIdentifier = "Show Search"
    static let ShowImageSegueIdentifier = "Show Image"
    static let RecentSearchTitle = "Recent Search"
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
    
    class func add(item: String) {
        var list = get() ?? [String]()
        if (!list.contains(item)) {
            if list.count > size {
                _ = list.removeLast()
            }
            list.insert(item, atIndex: 0)
            defaults.setObject(list, forKey: key)
        }
    }
    
    class func get() -> [String]? {
        if let list = defaults.arrayForKey(key) as? [String] {
            return list
        } else {
            return nil
        }
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

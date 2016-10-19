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
    static let ShowMentionSegueIdentifier = "Show Mention"
    static let ShowSearchSegueIdentifier = "Show Search"
    static let ShowImageSegueIdentifier = "Show Image"
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

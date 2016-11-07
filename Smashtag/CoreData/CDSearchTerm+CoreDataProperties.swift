//
//  CDSearchTerm+CoreDataProperties.swift
//  Smashtag
//
//  Created by Winnie on 6/11/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData


extension CDSearchTerm {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "CDSearchTerm");
    }

    @NSManaged public var searchTerm: String?
    @NSManaged public var mentions: NSSet?
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for mentions
extension CDSearchTerm {

    @objc(addMentionsObject:)
    @NSManaged public func addToMentions(value: CDMention)

    @objc(removeMentionsObject:)
    @NSManaged public func removeFromMentions(value: CDMention)

    @objc(addMentions:)
    @NSManaged public func addToMentions(values: NSSet)

    @objc(removeMentions:)
    @NSManaged public func removeFromMentions(values: NSSet)

}

// MARK: Generated accessors for tweets
extension CDSearchTerm {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(value: CDTweet)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(value: CDTweet)

    @objc(addTweets:)
    @NSManaged public func addToTweets(values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(values: NSSet)

}

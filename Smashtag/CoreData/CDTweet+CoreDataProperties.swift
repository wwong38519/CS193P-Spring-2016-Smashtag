//
//  CDTweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Winnie on 6/11/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import CoreData


extension CDTweet {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "CDTweet");
    }

    @NSManaged public var id: String?
    @NSManaged public var searchTerms: NSSet?

}

// MARK: Generated accessors for searchTerms
extension CDTweet {

    @objc(addSearchTermsObject:)
    @NSManaged public func addToSearchTerms(value: CDSearchTerm)

    @objc(removeSearchTermsObject:)
    @NSManaged public func removeFromSearchTerms(value: CDSearchTerm)

    @objc(addSearchTerms:)
    @NSManaged public func addToSearchTerms(values: NSSet)

    @objc(removeSearchTerms:)
    @NSManaged public func removeFromSearchTerms(values: NSSet)

}

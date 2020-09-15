//
//  DBMetric.swift
//  Trace
//
//  Created by Shams Ahmed on 23/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//
//

import Foundation
import CoreData

/// Internal use only
@objc(DBMetric)
@objcMembers
internal final class DBMetric: NSManagedObject, Identifiable {
    
    // MARK: - Enum
    
    enum Key: String {
        case name
        case json
        case date
    }

    // MARK: - Property
    
    /// Internal use only
    @NSManaged internal var name: String
    
    /// Internal use only
    @NSManaged internal var json: NSData
    
    /// Internal use only
    @NSManaged internal var date: Date
    
    // MARK: - Class - Fetch Request

    @nonobjc internal class func fetchRequest() -> NSFetchRequest<DBMetric> {
        return NSFetchRequest<DBMetric>(entityName: String(describing: DBMetric.self))
    }

    // MARK: - Init
    
    /// Internal use only
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}

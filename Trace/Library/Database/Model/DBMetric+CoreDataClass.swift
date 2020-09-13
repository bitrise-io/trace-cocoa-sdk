//
//  DBMetric+CoreDataClass.swift
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
internal final class DBMetric: NSManagedObject {
    
    // MARK: - NSManagedObject
    
    /// Internal use only
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}

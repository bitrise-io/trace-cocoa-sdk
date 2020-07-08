//
//  DBTrace+CoreDataClass.swift
//  Trace
//
//  Created by Shams Ahmed on 17/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import CoreData

/// Internal use only
internal final class DBTrace: NSManagedObject {
 
    // MARK: - NSManagedObject
    
    /// Internal use only
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}

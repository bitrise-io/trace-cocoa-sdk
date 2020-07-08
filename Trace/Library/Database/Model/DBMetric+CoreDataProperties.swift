//
//  DBMetric+CoreDataProperties.swift
//  Trace
//
//  Created by Shams Ahmed on 23/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//
//

import Foundation
import CoreData

extension DBMetric {
    
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
    
    // MARK: - Fetch Request

    @nonobjc internal class func fetchRequest() -> NSFetchRequest<DBMetric> {
        return NSFetchRequest<DBMetric>(entityName: String(describing: DBMetric.self))
    }
}

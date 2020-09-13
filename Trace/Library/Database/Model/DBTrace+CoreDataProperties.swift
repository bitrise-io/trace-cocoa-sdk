//
//  DBTrace+CoreDataProperties.swift
//  Trace
//
//  Created by Shams Ahmed on 17/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import CoreData

extension DBTrace {
    
    // MARK: - Enum
    
    enum Key: String {
        case traceId
        case json
        case date
    }
    
    // MARK: - Property
    
    /// Internal use only
    @NSManaged internal var traceId: String
    
    /// Internal use only
    @NSManaged internal var json: NSData
    
    /// Internal use only
    @NSManaged internal var date: Date
    
    // MARK: - Fetch Request
    
    @nonobjc internal class func fetchRequest() -> NSFetchRequest<DBTrace> {
        return NSFetchRequest<DBTrace>(entityName: String(describing: DBTrace.self))
    }
}

extension DBTrace: Identifiable { }

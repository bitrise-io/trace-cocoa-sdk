//
//  NSManagedObject+Entity.swift
//  Tests
//
//  Created by Shams Ahmed on 10/09/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObject {

    // MARK: - Init
    
    convenience init(using context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else {
            fatalError("Failed to create unit test entity in context")
        }
        
        print("Using Entity for unit testing CoreData database")
        
        self.init(entity: entity, insertInto: context)
    }
}

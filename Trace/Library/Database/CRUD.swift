//
//  CRUD.swift
//  Trace
//
//  Created by Shams Ahmed on 23/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import CoreData

/// CRUD
internal protocol CRUD {
    
    // MARK: - Type
    
    /// `NSManagedObject` type
    associatedtype T
    
    /// Data model type
    associatedtype M
    
    // MARK: - Property
    
    /// Persistent
    var persistent: Persistent { get set }
    
    /// completion
    var test_completion: (() -> Void)? { get set }
    
    // MARK: - Init
    
    init(with persistent: Persistent)
    
    // MARK: - Create
    
    func create(with model: M, save: Bool)
    func create(with models: [M], save: Bool, synchronous: Bool)
    
    // MARK: - Read
    
    // Have to implement in concrete class
    
    // MARK: - Update
    
    func update(id objectId: NSManagedObjectID, _ update: @escaping (inout T?) -> Bool)
    func update(ids objectIds: [NSManagedObjectID], _ update: @escaping (inout [T]) -> Bool)
    
    // MARK: - Delete
    
    func delete(_ object: T)
    func delete(_ objects: [T])
}

/// Helper to manage database objects without repeating code
internal extension CRUD where T: NSManagedObject {
    
    // MARK: - Update
    
    func update(id objectId: NSManagedObjectID, _ update: @escaping (inout T?) -> Bool) {
        persistent.privateContext.perform {
            let context = self.persistent.privateContext
            
            var object = context.object(with: objectId) as? T
            
            if update(&object) {
                try? context.save()
            }
            
            if self.test_completion != nil {
                DispatchQueue.main.async { self.test_completion?() }
            }
        }
    }
    
    func update(ids objectIds: [NSManagedObjectID], _ update: @escaping (inout [T]) -> Bool) {
        persistent.privateContext.perform {
            let context = self.persistent.privateContext
            
            var objects = objectIds
                .map { id -> T? in context.object(with: id) as? T }
                .compactMap { $0 }
            
            if update(&objects) {
                try? context.save()
            }
            
            if self.test_completion != nil {
                DispatchQueue.main.async { self.test_completion?() }
            }
        }
    }
    
    // MARK: - Delete
    
    func delete(_ object: T) {
        delete([object])
    }
    
    func delete(_ objects: [T]) {
        persistent.privateContext.perform {
            let context = self.persistent.privateContext
            
            // delete
            objects.forEach {
                let backgroundObject = context.object(with: $0.objectID)
                
                context.delete(backgroundObject)
            }
            
            // save
            try? context.save()
            
            if self.test_completion != nil {
                DispatchQueue.main.async { self.test_completion?() }
            }
        }
    }
}

/// Fetch
internal extension CRUD where T: NSManagedObject {
    
    // MARK: - Fetch
    
    var fetchRequest: NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: String(describing: T.self))
    }
    
    // pecker:ignore
    func fetchedResultsController(
        for context: Database.Context,
        sorting: [NSSortDescriptor],
        sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<T> {
        let managedObjectContext = context.managedObjectContext(for: persistent)
        
        let request = fetchRequest
        request.sortDescriptors = sorting
        
        return NSFetchedResultsController<T>(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil
        )
    }
    
    // MARK: - Count
    
    func count(in context: Database.Context) -> Int {
        let managedObjectContext = context.managedObjectContext(for: persistent)
        
        let request = fetchRequest
        request.resultType = .countResultType
        
        var count = 0
        
        if let countRequest = try? managedObjectContext.count(for: request) {
            count = countRequest
        }
        
        return count
    }
    
    // MARK: - Objects
    
    // pecker:ignore
    func one(in context: Database.Context, where predicate: NSPredicate?=nil) -> T? {
        let managedObjectContext = context.managedObjectContext(for: persistent)
        
        let request = fetchRequest
        request.fetchLimit = 1
        request.predicate = predicate
        
        let one = try? managedObjectContext.fetch(request)
        
        return one?.first
    }
    
    // pecker:ignore
    func all(in context: Database.Context, where predicate: NSPredicate?=nil, sort sortDescriptors: [NSSortDescriptor]?=nil, limit: Int?=nil) -> [T] {
        let managedObjectContext = context.managedObjectContext(for: persistent)
        
        let request = fetchRequest
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        var all = [T]()
        
        if let records = try? managedObjectContext.fetch(request) {
            all.append(contentsOf: records)
        }
        
        return all
    }
    
    func allInBackground(where predicate: NSPredicate?=nil, sort sortDescriptors: [NSSortDescriptor]?=nil, limit: Int?=nil, completion: @escaping ([T]) -> Void) {
        let request = fetchRequest
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        persistent.privateContext.perform {
            let context = self.persistent.privateContext
         
            var models = [T]()
            
            if let records = try? context.fetch(request) {
                models.append(contentsOf: records)
            }
            
            completion(models)
        }
    }
}

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
    
    func delete(_ objects: [NSManagedObjectID])
}

/// Helper to manage database objects without repeating code
internal extension CRUD where T: NSManagedObject {
    
    // MARK: - Update
    
    func update(id objectId: NSManagedObjectID, _ update: @escaping (inout T?) -> Bool) {
        let context = persistent.privateContext
        context.perform {
            var object = context.object(with: objectId) as? T
            
            if update(&object) {
                // save
                do {
                    try context.save()
                } catch {
                    Logger.error(.database, "Failed to save database after a update operation")
                }
            }
            
            if self.test_completion != nil {
                DispatchQueue.main.async { self.test_completion?() }
            }
        }
    }
    
    func update(ids objectIds: [NSManagedObjectID], _ update: @escaping (inout [T]) -> Bool) {
        let context = self.persistent.privateContext
        context.perform {
            var objects = objectIds
                .map { id -> T? in context.object(with: id) as? T }
                .compactMap { $0 }
            
            if update(&objects) {
                // save
                do {
                    try context.save()
                } catch {
                    Logger.error(.database, "Failed to save database after a update operation")
                }
            }
            
            if self.test_completion != nil {
                DispatchQueue.main.async { self.test_completion?() }
            }
        }
    }
    
    // MARK: - Delete
    
    func delete(_ ids: [NSManagedObjectID]) {
        let context = persistent.privateContext
        let hasMemoryPersistent = persistent.persistentStoreDescriptions
            .contains { $0.type == NSInMemoryStoreType }
        
        context.perform {
            do {
                // NSBatchDeleteRequest crashes when using in-memory store type
                if hasMemoryPersistent {
                    let objects: [NSManagedObject] = ids.compactMap {
                        try? context.existingObject(with: $0)
                    }

                    objects.forEach { context.delete($0) }
                } else {
                    let request = NSBatchDeleteRequest(objectIDs: ids)
                    
                    try context.execute(request)
                    try context.save()
                }
            } catch {
                Logger.error(.database, "Failed to save database after a delete operation")
            }
            
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
        var count = 0
        
        let managedObjectContext = context.managedObjectContext(for: persistent)
        managedObjectContext.performAndWait {
            let request = fetchRequest
            request.resultType = .countResultType
            
            do {
                count = try managedObjectContext.count(for: request)
            } catch {
                Logger.error(.database, "Cannot count DB record: \(error.localizedDescription)")
            }
        }
        
        return count
    }
    
    // MARK: - Objects
    
    // pecker:ignore
    func one(in context: Database.Context, where predicate: NSPredicate?=nil) -> T? {
        var model: T?
        
        let managedObjectContext = context.managedObjectContext(for: persistent)
        managedObjectContext.performAndWait {
            let request = fetchRequest
            request.fetchLimit = 1
            request.predicate = predicate
            
            do {
                model = try managedObjectContext.fetch(request).first
            } catch {
                Logger.error(.database, "Cannot fetch single request: \(error.localizedDescription)")
            }
        }
        
        return model
    }
    
    // pecker:ignore
    func all(in context: Database.Context, where predicate: NSPredicate?=nil, sort sortDescriptors: [NSSortDescriptor]?=nil, limit: Int?=nil) -> [T] {
        var all = [T]()
        
        let managedObjectContext = context.managedObjectContext(for: persistent)
        managedObjectContext.performAndWait {
            let request = fetchRequest
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            
            if let limit = limit {
                request.fetchLimit = limit
            }
            
            do {
                let records = try managedObjectContext.fetch(request)
                
                all.append(contentsOf: records)
            } catch {
                Logger.error(.database, "Cannot fetch request: \(error.localizedDescription)")
            }
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
        
        let context = persistent.privateContext
        context.perform {
            var models = [T]()
            
            do {
                let records = try context.fetch(request)
                
                models.append(contentsOf: records)
            } catch {
                Logger.error(.database, "Cannot fetch all in background: \(error.localizedDescription)")
            }
            
            completion(models)
        }
    }
}

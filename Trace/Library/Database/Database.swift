//
//  Database.swift
//  Trace
//
//  Created by Shams Ahmed on 23/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import CoreData

/// Database
final internal class Database {
    
    /// Database operation thread
    ///
    /// - view: READ ONLY: viewContext only for UI and mainthread
    /// - background: READ/Write: background used for performing operations
    internal enum Context {
        /// READ ONLY: viewContext only for UI and mainthread
        case view
        /// READ/Write: background used for performing operations
        case background
        
        // MARK: - Managed Object Context
        
        /// Managed object context in persistent
        ///
        /// - Parameter persistent: persistent
        /// - Returns: managedObjectContext
        internal func managedObjectContext(for persistent: Persistent) -> NSManagedObjectContext {
            switch self {
            case .view: return persistent.viewContext
            case .background: return persistent.privateContext
            }
        }
    }
    
    // MARK: - Property
    
    /// Persistent
    internal let persistent: Persistent = {
        let entities = Entities()
        let company = Constants.SDK.company.rawValue
        let name = Constants.SDK.name.rawValue
        
        let persistent = Persistent(
            name: company + name,
            managedObjectModel: entities.managedObjectModel
        )
        persistent.setup()
        
        return persistent
    }()
    
    // MARK: - DAO
    
    /// DAO container
    internal private(set) lazy var dao: DAO = DAO(with: persistent)
    
    // MARK: - Init
    
    internal init() {
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - State
    
    internal func saveAll(_ completion: (() -> Void)?=nil) {
        let context = persistent.privateContext
        context.performAndWait {
            // save
            do {
                try context.save()
            } catch {
                Logger.warning(.database, "Failed to save database after a delete operation")
            }
            
            completion?()
        }
    }
    
    /// Reset database
    internal func reset() {
        Logger.debug(.database, "Resetting database")
        
        let hasMemoryPersistent = persistent.persistentStoreDescriptions
            .contains { $0.type == NSInMemoryStoreType }
        
        // Test only
        if hasMemoryPersistent {
            persistent.viewContext.reset()
            persistent.privateContext.reset()
            persistent.newBackgroundContext().reset()
            
            persistent.persistentStoreCoordinator.persistentStores.forEach {
                try? persistent.persistentStoreCoordinator.remove($0)
            }
            
            // recreate
            persistent.setup()
            
            return
        }
        
        // Disk only
        let context = persistent.privateContext
        context.perform {
            let requests = [
                NSBatchDeleteRequest(fetchRequest: DBMetric.fetchRequest()),
                NSBatchDeleteRequest(fetchRequest: DBTrace.fetchRequest())
            ]
            requests.forEach { _ = try? context.execute($0) }
            
            // save
            do {
                try context.save()
            } catch {
                Logger.warning(.database, "Failed to reset database")
            }
        }
    }
}

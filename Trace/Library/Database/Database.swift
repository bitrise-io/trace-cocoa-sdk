//
//  Database.swift
//  Trace
//
//  Created by Shams Ahmed on 23/07/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
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
            case .background: return persistent.newBackgroundContext()
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
    
    internal func saveAll(_ competion: (() -> Void)?=nil) {
        persistent.privateContext.performAndWait { [weak self] in
            try? self?.persistent.privateContext.save()
            
            competion?()
        }
    }
    
    /// Reset database
    internal func reset() {
        Logger.print(.database, "Resetting database")
        
        let hasMemoryPersistent = persistent.persistentStoreDescriptions
            .contains { $0.type == NSInMemoryStoreType }
        
        // Test only
        if hasMemoryPersistent {
            persistent.viewContext.reset()
            
            persistent.persistentStoreCoordinator.persistentStores.forEach {
                try? persistent.persistentStoreCoordinator.remove($0)
            }
            
            // recreate
            persistent.setup()
            
            return
        }
        
        persistent.privateContext.perform { [weak self] in
            let context = self?.persistent.privateContext
            
            let requests = [
                NSBatchDeleteRequest(fetchRequest: DBMetric.fetchRequest()),
                NSBatchDeleteRequest(fetchRequest: DBTrace.fetchRequest())
            ]
            requests.forEach { _ = try? context?.execute($0) }
            
            try? context?.save()
        }
    }
}

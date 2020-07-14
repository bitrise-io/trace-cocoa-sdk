//
//  Persistent.swift
//  Trace
//
//  Created by Shams Ahmed on 23/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import CoreData

/// Internal use only
final internal class Persistent: NSPersistentContainer {
    
    // MARK: - Property
    
    lazy var privateContext: NSManagedObjectContext = self.newBackgroundContext()
    
    // MARK: - Setup
    
    internal func setup() {
        setupPersistentStore()
    }
    
    private func setupPersistentStore() {
        #if DEBUG || Debug || debug
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType

            persistentStoreDescriptions = [description]
        
            Logger.print(.database, "Using in-memory store while in debug mode.")
        #endif
        
        loadPersistentStores(completionHandler: { [weak self] _, error in
            if let error = error {
                let message = "load persistent stores error: \(error.localizedDescription)"
                
                Logger.print(.database, message)
            }
            
            self?.configureStores(error)
        })
    }
    
    // MARK: - Store
    
    private func configureStores(_ error: Error?) {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSErrorMergePolicy
    }
    
    // MARK: - File Location
    
    override internal static func defaultDirectoryURL() -> URL {
        var url = super.defaultDirectoryURL()
        url.appendPathComponent(Constants.SDK.company.rawValue)
        url.appendPathComponent("Database")
        
        return url
    }
}

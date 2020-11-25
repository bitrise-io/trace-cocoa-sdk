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
    
    // MARK: - Type
    
    private typealias Result = Swift.Result<Void, Error>
    
    // MARK: - Property
    
    lazy var privateContext: NSManagedObjectContext = self.newBackgroundContext()
    
    // MARK: - Setup
    
    internal func setup() {
        setupPersistentStore { [weak self] in
            switch $0 {
            case .success: break
            case .failure:
                Logger.warning(.database, "Persistent store failed, fallback set to in-memory store")
                
                self?.setupPersistentStore(inMemory: true)
            }
        }
    }
    
    private func setupPersistentStore(inMemory: Bool = false, _ completion: ((Result) -> Void)? = nil) {
        #if DEBUG || Debug || debug
            addInMemoryStore()
        
            Logger.debug(.database, "Using in-memory store while in debug mode")
        #else
            if inMemory {
                addInMemoryStore()
                
                Logger.warning(.database, "Using in-memory store")
            }
        #endif
        
        loadPersistentStores(completionHandler: { [weak self] _, error in
            if let error = error {
                let message = "loading persistent store error: \(error.localizedDescription)"
                
                Logger.warning(.database, message)
                
                completion?(.failure(error))
            } else {
                self?.configureStores(error)
                
                completion?(.success(()))
            }
        })
    }
    
    // MARK: - Store
    
    private func addInMemoryStore() {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        persistentStoreDescriptions = [description]
    }
    
    private func configureStores(_ error: Error?) {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSErrorMergePolicy
    }
    
    // MARK: - File Location
    
    override internal static func defaultDirectoryURL() -> URL {
        var url = super.defaultDirectoryURL()
        url.appendPathComponent(Constants.SDK.company.rawValue)
        url.appendPathComponent("Database")
        
        let fileManager = FileManager.default
        
        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                Logger.error(.database, "Failed to create directory with error: \(error.localizedDescription)")
            }
        }
        
        Logger.debug(.database, url.absoluteString)
            
        return url
    }
}

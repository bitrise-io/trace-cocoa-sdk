//
//  TraceDAO.swift
//  Trace
//
//  Created by Shams Ahmed on 17/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import CoreData

/// TraceDAO inherits CRUD protocol
internal final class TraceDAO: CRUD {
    
    // MARK: - Typealias
    
    /// Type DBTrace
    typealias T = DBTrace
    
    /// Model Trace
    typealias M = TraceModel
    
    // MARK: - Property
    
    unowned var persistent: Persistent
    
    var test_completion: (() -> Void)?
    
    // MARK: - Init
    
    required init(with persistent: Persistent) {
        self.persistent = persistent
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Create
    
    /// Create db model from data model
    ///
    /// - Parameter model: data model
    func create(with model: M, save: Bool) {
        create(with: [model], save: save, synchronous: false)
    }
    
    /// Create db models from data models
    ///
    /// - Parameter models: data models
    func create(with models: [M], save: Bool, synchronous: Bool) {
        let context = persistent.privateContext
        
        let function: () -> Void = { [weak self] in
            do {
                let _: [T?] = try models.map {
                    let date = Date()
                    let id = $0.traceId
                    let json = try $0.json() as NSData
                    
                    let className = String(describing: T.self)
                    let trace: T
                    
                    if let entity = self?.persistent.managedObjectModel.entitiesByName[className] {
                        // When unit testing, CoreData gets into difficulty in understanding which entity to use in memory since the are many tests that create them.
                        trace = T(entity: entity, insertInto: context)
                    } else {
                        trace = T(context: context)
                    }
                    
                    trace.traceId = id
                    trace.json = json
                    trace.date = date
                    
                    return trace
                }
                
                if save {
                    try context.save()
                }
                
                if self?.test_completion != nil {
                    DispatchQueue.main.async { self?.test_completion?() }
                }
            } catch {
                self?.deleteAffectedObjects(error)
            }
        }
        
        if synchronous {
            context.performAndWait(function)
        } else {
            context.perform(function)
        }
    }
    
    // MARK: - Error
    
    @discardableResult
    func deleteAffectedObjects(_ error: Error) -> Bool {
        let cocoaError = error as NSError
        let key = NSAffectedObjectsErrorKey
        
        if let affectedObjects = cocoaError.userInfo[key] as? [T] {
            func writtingTraceFailed() {
                Logger.warning(.database, "Writting trace failed. Removing affected objects \(affectedObjects.count)")
            }
            
            writtingTraceFailed()
            
            let affectedObjectIds = affectedObjects.map { $0.objectID }
            
            delete(affectedObjectIds)
            
            return true
        }
        
        return false
    }
}

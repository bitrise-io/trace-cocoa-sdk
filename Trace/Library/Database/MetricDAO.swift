//
//  MetricDAO.swift
//  Trace
//
//  Created by Shams Ahmed on 23/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import CoreData

/// MetricDAO inherits CRUD protocol
internal final class MetricDAO: CRUD {
    
    // MARK: - Typealias
    
    /// Type DBMetric
    typealias T = DBMetric
    
    /// Model Metric
    typealias M = Metric
    
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
    func create(with model: Metrics, save: Bool) {
        create(with: model.metrics, save: save, synchronous: false)
    }
    
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
        let function: () -> Void = {
            let context = self.persistent.privateContext
            
            do {
                let _: [T?] = try models.map {
                    let date = Date()
                    let name = $0.descriptor.name.rawValue
                    let json = try $0.json() as NSData
                    
                    let metric = T(context: context)
                    metric.name = name
                    metric.json = json
                    metric.date = date
                    
                    return metric
                }
                
                if save {
                    try context.save()
                }
                
                if self.test_completion != nil {
                    DispatchQueue.main.async { self.test_completion?() }
                }
            } catch {
                let cocoaError = error as NSError
                let key = NSAffectedObjectsErrorKey
                
                if let affectedObjects = cocoaError.userInfo[key] as? [T] {
                    Logger.print(.database, "Writting metric failed. Removing affected objects \(affectedObjects.count)")
                    
                    let affectedObjectIds = affectedObjects.map { $0.objectID }
                    
                    self.delete(affectedObjectIds)
                }
            }
        }
        
        if synchronous {
            persistent.privateContext.performAndWait(function)
        } else {
            persistent.privateContext.perform(function)
        }
    }
}

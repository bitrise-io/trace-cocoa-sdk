//
//  Entities.swift
//  Trace
//
//  Created by Shams Ahmed on 24/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import CoreData

/// Since our focus is to minimise weight of SDK and have it a static library we can't add files that are non-code.
/// Easy way would of been to use a bundle but that excess for a single file.
/// It's not well documented by Apple but it's possible to create a CoreData database purely in code.
/// This class creates the database structure with the tables and rules etc..
internal struct Entities {
    
    // MARK: - Property
    
    let managedObjectModel = NSManagedObjectModel()
    
    // MARK: - Entity
    
    internal var trace: NSEntityDescription {
        let name = String(describing: DBTrace.self)
        let managedObjectClassName: String
        
        if #available(iOS 12.0, *) {
            managedObjectClassName = String(reflecting: DBTrace.self) // Note: namespace is required
        } else {
            managedObjectClassName = name
        }
        
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = managedObjectClassName
        entity.properties = traceAttribute
        
        return entity
    }
    
    internal var metric: NSEntityDescription {
        let name = String(describing: DBMetric.self)
        let managedObjectClassName: String
        
        if #available(iOS 12.0, *) {
            managedObjectClassName = String(reflecting: DBMetric.self) // Note: namespace is required
        } else {
            managedObjectClassName = name
        }
        
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = managedObjectClassName
        entity.properties = metricAttribute
        
        return entity
    }
    
    // MARK: - Attribute
    
    /// Create Metrics db models
    private var metricAttribute: [NSAttributeDescription] {
        let name = NSAttributeDescription()
        name.name = DBMetric.Key.name.rawValue
        name.attributeType = .stringAttributeType
        name.isOptional = false
        name.allowsExternalBinaryDataStorage = false
        name.isIndexedBySpotlight = false
        
        let json = NSAttributeDescription()
        json.name = DBMetric.Key.json.rawValue
        json.attributeType = .binaryDataAttributeType
        json.isOptional = false
        json.allowsExternalBinaryDataStorage = false
        json.isIndexedBySpotlight = false
        
        let date = NSAttributeDescription()
        date.name = DBMetric.Key.date.rawValue
        date.attributeType = .dateAttributeType
        date.isOptional = false
        date.allowsExternalBinaryDataStorage = false
        date.isIndexedBySpotlight = false
        
        return [name, json, date]
    }
    
    /// Create Trace db models
    private var traceAttribute: [NSAttributeDescription] {
        let id = NSAttributeDescription()
        id.name = DBTrace.Key.traceId.rawValue
        id.attributeType = .stringAttributeType
        id.isOptional = false
        id.allowsExternalBinaryDataStorage = false
        id.isIndexedBySpotlight = false
        
        let json = NSAttributeDescription()
        json.name = DBTrace.Key.json.rawValue
        json.attributeType = .binaryDataAttributeType
        json.isOptional = false
        json.allowsExternalBinaryDataStorage = false
        json.isIndexedBySpotlight = false
        
        let date = NSAttributeDescription()
        date.name = DBTrace.Key.date.rawValue
        date.attributeType = .dateAttributeType
        date.isOptional = false
        date.allowsExternalBinaryDataStorage = false
        date.isIndexedBySpotlight = false
        
        return [id, json, date]
    }
    
    // MARK: - Init
    
    init() {
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        managedObjectModel.entities = [metric, trace]
        // Indexing would be nice...
    }
}

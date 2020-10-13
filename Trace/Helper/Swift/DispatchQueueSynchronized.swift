//
//  DispatchQueueSynchronized.swift
//  Trace
//
//  Created by Shams Ahmed on 13/10/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

struct DispatchQueueSynchronized {
    
    // MARK: - Property
    
    private let dispatchQueue: DispatchQueue
    private let specificKey = DispatchSpecificKey<String>()
    private let specificValue: String
    
    // MARK: - Init
    
    init(label: String, qos: DispatchQoS) {
        dispatchQueue = DispatchQueue(label: label, qos: qos)
        specificValue = label
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        dispatchQueue.setSpecific(key: specificKey, value: specificValue)
    }
    
    // MARK: - Async
    
    func async(_ execute: @escaping () -> Void) {
        dispatchQueue.async(execute: execute)
    }
    
    // MARK: - Sync
    
    func sync(_ execute: () -> Void) {
        if DispatchQueue.getSpecific(key: specificKey) == specificValue {
            execute()
        } else {
            dispatchQueue.sync(execute: execute)
        }
    }
}

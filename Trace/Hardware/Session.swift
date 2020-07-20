//
//  Session.swift
//  Trace
//
//  Created by Shams Ahmed on 13/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Session
final class Session {
    
    // MARK: - Property
    
    private let repeater: Repeater
    private let delay: Double
    
    var resource: Resource? {
        didSet {
            resource?.session = uuid.string
            
            if let resources = try? resource?.dictionary() {
                // TODO: use enum instead of string
                Trace.shared.crash.userInfo["Resource"] = resources
            }
            
            if let oldValue = oldValue {
                resource?.network = oldValue.network
            } else {
                Logger.print(.application, "Resource created for this session")
            }
        }
    }
    
    var uuid: ULID {
        didSet {
            resource?.session = uuid.string
        }
    }
    
    // MARK: - Init
    
    // Update the session every 15 seconds
    internal init(timeout: Double = 15.0, delay: Double = 0.05) {
        self.repeater = Repeater(timeout)
        self.delay = delay
        self.uuid = ULID()

        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let handler: () -> Void = { [weak self] in
            self?.sendHardwareDetails()
        }
        
        repeater.state = .resume
        repeater.handler = handler
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + delay,
            execute: { [weak self] in self?.updateResource() }
        )
    }
    
    // MARK: - Device
    
    private func updateResource() {
        let deviceFormatter = DeviceFormatter()
        
        resource = Resource(from: deviceFormatter.details)
    }
    
    private func sendHardwareDetails() {
        let cpu = CPU()
        let memory = Memory()
        let connectivity = Connectivity()
        let hardwareFormatter = HardwareFormatter(
            cpu: cpu,
            memory: memory,
            connectivity: connectivity
        )
        
        if let interface = connectivity.interface.interface {
            resource?.network = interface
        }
        
        Trace.shared.queue.add(hardwareFormatter.metrics)
    }
    
    // MARK: - State
    
    func restart() {
        repeater.state = .resume
        
        DispatchQueue.main.async { [weak self] in self?.updateResource() }
        
        uuid = ULID()
    }
}

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
    
    /// Setter: use method self.updateResource() or init
    var resource: Resource {
        didSet {
            resource.session = uuid.string
            
            if !oldValue.network.isEmpty && resource.network.isEmpty {
                resource.network = oldValue.network
            }
            
            if let resources = try? resource.dictionary() {
                Trace.shared.crash.userInfo[CrashController.Keys.resource.rawValue] = resources
            }
        }
    }
    
    var uuid: ULID {
        didSet {
            resource.session = uuid.string
        }
    }
    
    // MARK: - Init
    
    // Update the session every 15 seconds
    internal init(timeout: Double = 15.0, delay: Double = 0.10) {
        let deviceFormatter = DeviceFormatter()
        let details = deviceFormatter.details
        
        self.repeater = Repeater(timeout)
        self.delay = delay
        self.uuid = ULID()
        self.resource = Resource(
            from: details,
            sessionId: uuid.string
        )
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let handler: () -> Void = { [weak self] in
            self?.sendHardwareDetails()
        }
        
        repeater.state = .resume
        repeater.handler = handler
        
        // Must use main thread for resource
        DispatchQueue.main.asyncAfter(
            deadline: .now() + delay,
            execute: { [weak self] in
                self?.updateResource()
                self?.sendHardwareDetails()
            }
        )
    }
    
    // MARK: - Device
    
    private func updateResource() {
        Logger.debug(.application, "Resource updated for current session")
        
        let deviceFormatter = DeviceFormatter()
        let details = deviceFormatter.details
        
        resource = Resource(from: details)
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
        
        if let interface = connectivity.interface.interface,
           !interface.isEmpty,
           resource.network != interface {
            resource.network = interface
        }
        
        Trace.shared.queue.add(hardwareFormatter.metrics)
    }
    
    // MARK: - State
    
    func restart() {
        repeater.state = .resume
        
        DispatchQueue.main.async { [weak self] in
            self?.updateResource()
            self?.sendHardwareDetails()
        }
        
        uuid = ULID()
    }
}

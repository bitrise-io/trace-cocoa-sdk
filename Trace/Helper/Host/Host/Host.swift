//
//  Host.swift
//  Trace
//
//  Created by Shams Ahmed on 23/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal protocol HostProtocol {
    
    // MARK: - Property
    
    var machHost: mach_port_t { get }
    var hostBasicInfo: host_basic_info { get }
}

/// Get information about the device
internal struct Host: HostProtocol {
    
    // MARK: - Property - Key
    
    private let HOST_BASIC_INFO_COUNT: mach_msg_type_number_t =
        UInt32(MemoryLayout<host_basic_info_data_t>.size / MemoryLayout<integer_t>.size)
    
    // MARK: - Property
    
    internal var machHost = mach_host_self()
    
    /// Capture app detils
    internal var hostBasicInfo: host_basic_info {
        var size = HOST_BASIC_INFO_COUNT
        var hostInfo = host_basic_info()
        
        _ = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size), {
                host_info(machHost, HOST_BASIC_INFO, $0, &size)
            })
        }
    
        return hostInfo
    }
    
    // MARK: - Init
    
    internal init() {
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
}

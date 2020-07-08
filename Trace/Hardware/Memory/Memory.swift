//
//  Memory.swift
//  Trace
//
//  Created by Shams Ahmed on 22/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal protocol MemoryProtocol {
    
    // MARK: - Property
    
    var applicationUsage: Memory.ApplicationUsage { get }
    var systemUsage: Memory.SystemUsage { get }
}

/// Memory
internal struct Memory: MemoryProtocol {
    
    // MARK: - Property - Key
    
    private let HOST_VM_INFO64_COUNT: mach_msg_type_number_t =
        UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
    private let PAGE_SIZE: Double = Double(vm_kernel_page_size)
    
    // MARK: - Struct
    
    struct SystemUsage: Encodable {
        let free, active, inactive, wired, compressed, total: Double
        let timestamp: Time.Timestamp
    }
    
    struct ApplicationUsage: Encodable {
        let used, total: Double
        let timestamp: Time.Timestamp
    }
    
    // MARK: - Property - Private
    
    private let host = Host()
    private let totalBytes = Double(ProcessInfo.processInfo.physicalMemory)
 
    // MARK: - Property
    
    internal var applicationUsage: ApplicationUsage {
        let timestamp = Time.timestamp
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
        
        let kerr = withUnsafeMutablePointer(to: &info) {
            return $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                return task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count )
            }
        }
        
        guard kerr == KERN_SUCCESS else { return ApplicationUsage(used: 0, total: totalBytes, timestamp: timestamp) }
        
        return ApplicationUsage(used: Double(info.resident_size), total: totalBytes, timestamp: timestamp)
    }
    
    internal var systemUsage: SystemUsage {
        let timestamp = Time.timestamp
        let statistics = VMStatistics64()
        let free = Double(statistics.free_count) * PAGE_SIZE
        let active = Double(statistics.active_count) * PAGE_SIZE
        let inactive = Double(statistics.inactive_count) * PAGE_SIZE
        let wired = Double(statistics.wire_count) * PAGE_SIZE
        let compressed = Double(statistics.compressor_page_count) * PAGE_SIZE
        
        return SystemUsage(
            free: free,
            active: active,
            inactive: inactive,
            wired: wired,
            compressed: compressed,
            total: totalBytes,
            timestamp: timestamp
        )
    }
    
    // MARK: - Init
    
    internal init() {
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Statistics
   
    private func VMStatistics64() -> vm_statistics64 {
        var size = HOST_VM_INFO64_COUNT
        var hostInfo = vm_statistics64()
        
        _ = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics64(host.machHost, HOST_VM_INFO64, $0, &size)
            }
        }
        
        return hostInfo
    }
}

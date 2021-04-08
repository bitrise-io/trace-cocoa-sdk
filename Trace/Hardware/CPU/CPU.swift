//
//  CPU.swift
//  Trace
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal protocol CPUProtocol {
   
    // MARK: - Property
    
    var physicalCores: Int { get }
    var logicalCores: Int { get }
    var systemUsage: CPU.SystemUsage { get }
    var perThreadUsage: [CPU.PerThreadUsage] { get }
    var applicationUsage: CPU.ApplicationUsage { get }
}

internal final class CPU: CPUProtocol {

    // MARK: - Property - Key
    
    private let HOST_CPU_LOAD_INFO_COUNT: mach_msg_type_number_t =
        UInt32(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)
    
    // MARK: - Struct
    
    struct SystemUsage: Encodable {
        let system, user, idle, nice: Double
        let timestamp: Time.Timestamp
    }
    
    struct ApplicationUsage: Encodable {
        let overall: Double
        let timestamp: Time.Timestamp
    }
    
    struct PerThreadUsage: Encodable {
        let name: String
        let usage: Double
        let timestamp: Time.Timestamp
    }
    
    // MARK: - Property - Private
    
    private let host = Host()
    private var infoPrevious = host_cpu_load_info()
    
    private var hostCPULoadInfo: host_cpu_load_info {
        var info = host_cpu_load_info()
        var size = HOST_CPU_LOAD_INFO_COUNT
        
        _ = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics(host.machHost, HOST_CPU_LOAD_INFO, $0, &size)
            }
        }
        
        return info
    }
    
    // MARK: - Property
    
    internal var physicalCores: Int { return Int(host.hostBasicInfo.physical_cpu) }
    internal var logicalCores: Int { return Int(host.hostBasicInfo.logical_cpu) }
    
    internal var systemUsage: SystemUsage {
        let timestamp = Time.timestamp
        let info = hostCPULoadInfo
        
        let userDiff = Double(info.cpu_ticks.0 - infoPrevious.cpu_ticks.0)
        let systemDiff = Double(info.cpu_ticks.1 - infoPrevious.cpu_ticks.1)
        let idleDiff = Double(info.cpu_ticks.2 - infoPrevious.cpu_ticks.2)
        let niceDiff = Double(info.cpu_ticks.3 - infoPrevious.cpu_ticks.3)
        let totalTicks = systemDiff + userDiff + niceDiff + idleDiff
        let system = systemDiff / totalTicks * 100.0
        let user = userDiff / totalTicks * 100.0
        let idle = idleDiff / totalTicks * 100.0
        let nice = niceDiff / totalTicks * 100.0
        
        infoPrevious = info
        
        return SystemUsage(system: system, user: user, idle: idle, nice: nice, timestamp: timestamp)
    }
    
    internal var applicationUsage: ApplicationUsage {
        let timestamp = Time.timestamp
        let currentThreads = threads()
        var result: Double = 0.0
        
        currentThreads.values.forEach {
            if flag($0) {
                result += Double($0.cpu_usage) / Double(TH_USAGE_SCALE)
            }
        }
        
        return ApplicationUsage(overall: result * 100, timestamp: timestamp)
    }
    
    internal var perThreadUsage: [PerThreadUsage] {
        let timestamp = Time.timestamp
        let currentThreads = threads()
        let result = currentThreads.map { key, value -> PerThreadUsage in
            let usage = (Double(value.cpu_usage) / Double(TH_USAGE_SCALE)) * 100
            
            return PerThreadUsage(name: key, usage: usage, timestamp: timestamp)
        }
        
        return result
    }
    
    // MARK: - Init
    
    internal init() {
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Threads

    private func flag(_ thread: thread_basic_info) -> Bool {
        let result = thread.flags & TH_FLAGS_IDLE
        let number = NSNumber(value: result)
        
        return !Bool(truncating: number)
    }
   
    private func threadActPointers() -> [thread_act_t] {
        var threads_act = [thread_act_t]()
        var threads_array: thread_act_array_t?
        var count = mach_msg_type_number_t()
        
        _ = task_threads(mach_task_self_, &(threads_array), &count)
        
        guard let array = threads_array else { return threads_act }
        
        for i in 0..<count {
            threads_act.append(array[Int(i)])
        }
        
        let krsize = count * UInt32(MemoryLayout<thread_t>.size)
        
        _ = vm_deallocate(mach_task_self_, vm_address_t(array.pointee), vm_size_t(krsize))
        
        return threads_act
    }
    
    // Get name and details of the thread
    private func threads() -> [String: thread_basic_info] {
        let count: Int = MemoryLayout<thread_basic_info_data_t>.size / MemoryLayout<integer_t>.size
        var result = [String: thread_basic_info]()
        
        for act_t in threadActPointers() {
            var name = String(act_t)

            if let pthread = pthread_from_mach_thread_np(act_t) {
                var raw: [Int8] = Array(repeating: 0, count: 256)
                
                _ = pthread_getname_np(pthread, &raw, raw.count)

                if let realName = String(utf8String: raw), !realName.isEmpty {
                    name = realName
                }
                
                if name.isEmpty {
                    name = "Unknown thread \(Int.random(in: 0...10000))"
                }
            }

            var thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
            var thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
            let kr = thread_info(act_t, thread_flavor_t(THREAD_BASIC_INFO), &thinfo, &thread_info_count)

            guard kr == KERN_SUCCESS else { continue }

            let basic_info_th = withUnsafePointer(to: &thinfo, {
                return $0.withMemoryRebound(to: thread_basic_info_t.self, capacity: count, {
                    return $0.pointee
                })
            })

            result[name] = basic_info_th.pointee
        }
        
        return result
    }
}

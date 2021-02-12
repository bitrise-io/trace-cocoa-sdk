//
//  FileManager+Space.swift
//  Trace
//
//  Created by Shams Ahmed on 02/06/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Helper to find out device disk space details
extension FileManager {
    
    // MARK: - Disk
    
    var totalDiskSpace: String {
        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: .decimal)
    }
    
    var freeDiskSpace: String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: .decimal)
    }
    
    var usedDiskSpace: String {
        let usedDiskSpaceInBytes = totalDiskSpaceInBytes - freeDiskSpaceInBytes
        
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: .decimal)
    }
    
    // MARK: - Raw
    
    private var totalDiskSpaceInBytes: Int64 {
        let directory = NSHomeDirectory() as String
        var totalSpace: Int64 = 0
        
        if #available(iOS 11.0, *) {
            // Since iOS 11 this information is provided high level
            let fileURL = URL(fileURLWithPath: directory)
            let url: Int?? = try? fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey]).volumeTotalCapacity
        
            if let unwrappedSpace = url, let space = unwrappedSpace {
                totalSpace = Int64(space)
            }
        }
        
        // Finds the details by using OS file system metadata
        if totalSpace == 0, let attributes = try? attributesOfFileSystem(forPath: directory), let space = (attributes[.systemSize] as? NSNumber)?.int64Value {
            totalSpace = space
        }
        
        return totalSpace
    }
    
    private var freeDiskSpaceInBytes: Int64 {
        let directory = NSHomeDirectory() as String
        var totalSpace: Int64 = 0
        
        if #available(iOS 11.0, *) {
            // Since iOS 11 this information is provided high level
            let fileURL = URL(fileURLWithPath: directory)
            let url: Int64?? = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage
        
            if let unwrappedSpace = url, let space = unwrappedSpace {
                totalSpace = space
            }
        }
        
        // Finds the details by using OS file system metadata
        if totalSpace == 0, let systemAttributes = try? attributesOfFileSystem(forPath: directory),
            let freeSpace = (systemAttributes[.systemFreeSize] as? NSNumber)?.int64Value {
            totalSpace = freeSpace
        }
        
        return totalSpace
    }
}

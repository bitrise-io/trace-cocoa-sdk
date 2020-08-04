//
//  UIDevice+Jailbreak.swift
//  Trace
//
//  Created by Shams Ahmed on 06/01/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit

/// helper to find out if device has been jailbroken
extension UIDevice {
    
    // MARK: - Jailbroke
    
    internal struct Jailbroke {

        // MARK: - Property
        
        /// One of the many ways to check if a device is jailbroken by checking is the app has access to a certain path
        var containsSuspiciousPathsTests: Bool {
            let manager = FileManager.default
            let possiblePaths = [
                "/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/Applications/Cydia.app",
                "/etc/apt",
                "/private/var/lib/apt/",
                "/bin/bash",
                "/usr/sbin/sshd"
            ]
            let exists = possiblePaths.firstIndex(where: { manager.fileExists(atPath: $0) })
            
            return exists != nil
        }
    }
    
    // MARK: - Jailbroken Check
    
    var isJailbroken: Bool {
        let result: Bool
        
        #if targetEnvironment(simulator) || targetEnvironment(macCatalyst)
            result = false
        #else
            let jailbroke = Jailbroke()
            
            result = jailbroke.containsSuspiciousPathsTests
        #endif
        
        return result
    }
}

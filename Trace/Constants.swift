//
//  Constants.swift
//  Trace
//
//  Created by Shams Ahmed on 21/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal enum Constants {
 
    // MARK: - SDK
    
    internal enum SDK: String {
        case company = "Bitrise"
        case name = "Trace"
        case version = "1.7.36" // Static library does not include a .plist with details about package. Would be nice to automate this the version details on this class
    }
    
    // MARK: - URL
    
    /// I know... but this is unlikely to fail. Covered by loads of unit tests
    internal static var API: URL! = URL(string: "https://collector.apm.bitrise.io")
}

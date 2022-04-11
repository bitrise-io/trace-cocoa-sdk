//
//  SwiftOnlyLoad.swift
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

@_exported import Foundation
import UIKit
import ObjectiveC
    
/// Internal use only
/// This class may depend on having -ObjC in Other linker flags
extension UIApplication {
    
    // MARK: - Property
    
    /// Third and last attempt at starting SDK
    /// Uses the run loop to start th SDK.
    /// This stage is very late in the app's initialisation
    private static let bitrise_run: Void = {
        func BITRISE_WILL_START_TRACE() {
            
        }
        func BITRISE_DID_START_TRACE() {
            
        }
        
        // Fallback plan if the SDK doesn't start using -force_load approach
        BITRISE_WILL_START_TRACE()
        
        guard Trace.configuration.enabled else { return }
        
        // Update session timeout values only if the SDK hasn't been started yet
        if Trace.currentSession == 0 {
            Trace.reset()
            
            let company = Constants.SDK.company.rawValue
            let name = Constants.SDK.name.rawValue
            let message = company + " " + name + " " + "starting up using application's runloop"
            
            Logger.warning(.launch, message)
        }
        
        // Start SDK
        _ = Trace.shared
        
        BITRISE_DID_START_TRACE()
    }()
    
    // MARK: - Override
    
    /// Internal use only
    override open var next: UIResponder? {
        // Method is only called once.
        UIApplication.bitrise_run // Called before applicationDidFinishLaunching since the app delegate conforms to UIResponder class by default on all Xcode projects. For others that use a custom version this would fail
        
        return super.next
    }
}

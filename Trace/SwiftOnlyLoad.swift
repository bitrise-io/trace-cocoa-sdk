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

/// Class to help with finding main SDK gateway
private protocol SelfAware: AnyObject {
    
    // MARK: - Awake
    
    static func awake()
}

/// Internal use only
internal final class SwiftOnlyLoad: NSObject, SelfAware {
    
    // MARK: - SelfAware
    
    /// Third and last attempt at starting SDK
    /// Uses the run loop to start th SDK.
    /// This stage is very late in the app's initialisation
    static func awake() {
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
    }
}

/// Internal use only
/// This class may depend on having -ObjC in Other linker flags
extension UIApplication {
    
    // MARK: - Property
    
    private static let bitrise_run: Void = {
        guard Trace.configuration.enabled else { return }
        
        // Get a list of classes thanks to Objective-c runtime
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        
        // Should this be Async???
        for index in 0 ..< typeCount {
            // Check if the class conforms to protocol and than calls the awake method
            // Note: list is very long
            // Is there a way to check who conforms to UIApplicationDelegate protocol?
            (types[index] as? SelfAware.Type)?.awake()
            
              // list all the classes in app
              // print(types[index].self)
        }
        
        // clean up
        types.deallocate()
    }()
    
    // MARK: - Override
    
    /// Internal use only
    override open var next: UIResponder? {
        func BITRISE_WILL_START_TRACE() {
            
        }
        func BITRISE_DID_START_TRACE() {
            
        }
        
        // Fallback plan if the SDK doesn't start using -force_load approach
        BITRISE_WILL_START_TRACE()
        
        // Method is only called once.
        UIApplication.bitrise_run // Called before applicationDidFinishLaunching since the app delegate conforms to UIResponder class by default on all Xcode projects. For others that use a custom version this would fail
        
        BITRISE_DID_START_TRACE()
        
        return super.next
    }
}

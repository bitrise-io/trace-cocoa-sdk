//
//  TraceConfigurationInteractor.swift
//  Trace
//
//  Created by Shams Ahmed on 11/08/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal struct TraceConfigurationInteractor {
    
    // MARK: - Property
    
    let network: Network
    
    // MARK: - Setup
    
    // called outside of class
    @discardableResult
    func setup() -> Bool {
        var result = false
        
        do {
            // Check configuration file
            let configuration = try BitriseConfigurationInteractor()
            network.authorization = configuration.model.token
            
            if let environment = configuration.model.environment {
                Constants.API = environment
            }
            
            if let source = configuration.model.installationSource, !source.isEmpty, source != " " {
                network.configuration.additionalHeaders[.installationSource] = source
            }
            
            Logger.print(.launch, "Bitrise Trace setup complete")
            
            result = true
        } catch {
            Logger.error(.internalError, "Application failed to read the configuration file, all data will be cached until it's resolved. Please review getting started guide on https://trace.bitrise.io/o/getting-started")
            
            result = false
        }
        
        #if DEBUG || Debug || debug
        // Check XCode environment variables. this only works when running with a debugger i.e in Run app or Tests
        let environment = ProcessInfo.processInfo.environment
        
        if let configuration = try? BitriseConfiguration(dictionary: environment) {
            Logger.print(.application, "Overriding configuration from Xcode environment variables")
                
            network.authorization = configuration.token
            
            if let api = configuration.environment {
                Constants.API = api
                
                result = true
            }
        }
        #endif
        
        return result
    }
}

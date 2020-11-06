//
//  BitriseConfigurationInteractor.swift
//  Trace
//
//  Created by Shams Ahmed on 18/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal final class BitriseConfigurationInteractor {
    
    // MARK: - Enum
    
    /// Error
    ///
    /// - configurationFileMissingFromMainBundle: Bitrise configuration file is missing from Bundle.main.
    enum Error: Swift.Error {
        /// Bitrise configuration file is missing from Bundle.main.
        case configurationFileMissingFromMainBundle
    }
    
    // MARK: - Property
    
    private static let `extension` = "plist"
    private static let resource = "bitrise_configuration"
    
    internal let model: BitriseConfiguration
    
    // MARK: - Init
    
    internal init(with bundle: Bundle = .main) throws {
        let resource = BitriseConfigurationInteractor.resource
        let `extension` = BitriseConfigurationInteractor.`extension`
        
        guard let url = bundle.url(forResource: resource, withExtension: `extension`) else {
            let company = Constants.SDK.company.rawValue
            let message = company + " " + "configuration file is missing from Bundle.main"
            
            Logger.error(.internalError, message)
            
            throw Error.configurationFileMissingFromMainBundle
        }
        
        let data = try Data(contentsOf: url)
        model = try PropertyListDecoder().decode(BitriseConfiguration.self, from: data)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
}

//
//  Network+Configuration.swift
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

extension Network {
    
    // MARK: - Configuration
    
    final internal class Configuration {

        // MARK: - Configuration
        
        /// Default configuration with timeout set to 15 seconds,
        static var `default`: URLSessionConfiguration {
            let company = Constants.SDK.company.rawValue
            let sdk = Constants.SDK.name.rawValue
            let version = Constants.SDK.version.rawValue
            let userAgent: String = "\(company)/\(sdk) Cocoa:" + " \(version)"
            let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
            let acceptLanguage: String = Locale.preferredLanguages.prefix(6).enumerated().map {
                let quality = 1.0 - (Double($0.offset) * 0.1)
            
                return "\($0.element);q=\(quality)"
            }.joined(separator: ", ")

            let configuration: URLSessionConfiguration = .ephemeral
            configuration.timeoutIntervalForResource = 15.0
            configuration.timeoutIntervalForRequest = 15.0
            configuration.httpAdditionalHeaders = [
                Header.userAgent.rawValue: userAgent,
                Header.acceptEncoding.rawValue: acceptEncoding,
                Header.acceptLanguage.rawValue: acceptLanguage,
                Header.contentType.rawValue: MIMEType.json.rawValue,
                Header.accept.rawValue: MIMEType.json.rawValue
            ]
            
            return configuration
        }

        // MARK: - Authorization

        /// Inject additional headers, by default .userAgent, .acceptEncoding & .acceptLanguage are set.
        var additionalHeaders: [Header: String] = [:]
    }
}

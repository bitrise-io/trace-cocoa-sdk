//
//  Network+Validation.swift
//  Trace
//
//  Created by Shams Ahmed on 12/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension Network {

    // MARK: - Response Validation

    func validate(_ data: Data?, _ response: URLResponse?, _ error: Swift.Error?, completion: @escaping (Completion) -> Void) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        if let statusCode = statusCode,
            successStatusCodes.contains(statusCode) {
            completion(.success(data))
        } else if let statusCode = statusCode,
            clientStatusCodes.contains(statusCode) {
            if statusCode == StatusCode.unauthorized.rawValue {
                Logger.error(.application, "Authentication token is unauthorized, please validate on Trace setting page: https://trace.bitrise.io/settings")
            }
            
            completion(.failure(.client))
        } else if let statusCode = statusCode,
            serverStatusCodes.contains(statusCode) {
            completion(.failure(.server))
        } else {
            completion(.failure(.unknown(error: error)))
        }
    }
}

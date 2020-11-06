//
//  Network+Request.swift
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension Network {

    // MARK: - Request

    /// Make a network request
    ///
    /// - Parameters:
    ///   - request: Router enum with Routable
    ///   - completion: Result of request
    /// - Returns: Task used for cancelling
    @discardableResult
    func request(_ request: Routable, _ completion: @escaping (Completion) -> Void) -> URLSessionDataTask? {
        // validate url request
        guard var url = try? request.asURLRequest() else {
            Logger.error(.network, "Invalid url request with: \(request.path)")
            
            completion(.failure(.invalidURL))
            
            return nil
        }
        guard !configuration.additionalHeaders.isEmpty else {
            Logger.error(.network, "Request cached as bitrise_configuration.plist file has not been set. Please review getting started guide on https://trace.bitrise.io/o/getting-started")
            
            completion(.failure(.noAuthentication))
            
            return nil
        }

        // add auth
        configuration.additionalHeaders.forEach {
            url.addValue($0.value, forHTTPHeaderField: $0.key.rawValue)
        }

        // network async request
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            self?.validate(data, response, error, completion: completion)
        }

        // start request
        task.resume()

        return task
    }
}

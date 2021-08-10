//
//  Routable.swift
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Routable
internal protocol Routable {

    // MARK: - Property

    /// Base URL
    static var baseURL: URL { get }
    
    /// HTTP Method
    var method: HTTPNetwork.Method { get }
    
    /// Endpoint
    var path: String { get }
    
    // MARK: - Request
    
    /// Create URL request from protocol requirements
    ///
    /// - Returns: request
    /// - Throws: error
    func asURLRequest() throws -> URLRequest
}

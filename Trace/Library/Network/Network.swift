//
//  Network.swift
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

protocol Networkable {
    
    // MARK: - Typealias
    
    typealias Completion = Result<Data?, Network.Error>
    
    // MARK: - Network
    
    func request(_ request: Routable, _ completion: @escaping (Completion) -> Void) -> URLSessionDataTask?
    func upload(_ request: Routable, name: String, file: Data, parameters: [String: Any]?, _ completion: @escaping (Completion) -> Void) -> URLSessionDataTask?
    
    func reset()
}

/// Common network manager
final internal class Network: Networkable {
    
    /// Request completion
    internal typealias Completion = Result<Data?, Error>

    // MARK: - Property

    /// Session
    internal let session: URLSession

    /// Configuration
    internal let configuration = Configuration()
    
    internal var authorization: String? {
        get {
            return configuration.additionalHeaders[.authorization]
        }
        set {
            if let authorization = newValue {
                configuration.additionalHeaders[.authorization] = "Bearer \(authorization)"
            } else {
                configuration.additionalHeaders[.authorization] = nil
            }
        }
    }

    // MARK: - Init

    /// Network
    internal init(configuration: URLSessionConfiguration = Configuration.default) {
        session = URLSession(configuration: configuration)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }

    // MARK: - Reset
    
    /// Empties all cookies, disk/caches & credential stores.
    internal func reset() {
        session.reset { }
        session.flush { }
        
        session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
}

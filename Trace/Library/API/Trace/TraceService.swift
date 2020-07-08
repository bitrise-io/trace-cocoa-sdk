//
//  TraceService.swift
//  Trace
//
//  Created by Shams Ahmed on 29/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal struct TraceService {
    
    // MARK: - Property
    
    private let network: Networkable
    
    // MARK: - Init
    
    internal init(network: Networkable) {
        self.network = network
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Steps
    
    @discardableResult
    internal func trace(with model: TraceModel, _ completion: @escaping (Result<Data?, Network.Error>) -> Void) -> URLSessionDataTask? {
        return network.request(Router.trace(model)) {
            completion($0)
            
            switch $0 {
            case .success:
                break
            case .failure:
                break
            }
        }
    }
}

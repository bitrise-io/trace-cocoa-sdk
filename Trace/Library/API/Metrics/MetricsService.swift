//
//  MetricsService.swift
//  Trace
//
//  Created by Shams Ahmed on 31/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal struct MetricsService {
    
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
    
    // MARK: - Details
    
    @discardableResult
    internal func metrics(with model: Metrics, _ completion: @escaping (Result<Data?, Network.Error>) -> Void) -> URLSessionDataTask? {
        return network.request(Router.metrics(model)) {
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

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
    internal func metrics(with model: Metrics, _ completion: @escaping (Result<(data: Data?, response: HTTPURLResponse?), Network.Error>) -> Void) -> URLSessionDataTask? {
        let metricsNames = model.metrics.map { $0.descriptor.name.rawValue }
        
        return network.request(Router.metrics(model)) {
            completion($0)
            
            switch $0 {
            case .success((_, let response)): self.validate(response: response, for: metricsNames)
            case .failure: break
            }
        }
    }
    
    // MARK: - Validate Response
    
    @discardableResult
    private func validate(response: HTTPURLResponse?, for metrics: [String]) -> Bool {
        guard let headers = response?.allHeaderFields as? [String: String] else { return false }
        
        if let acceptedCount = headers[Network.MIMEType.acceptedMetricsCount.rawValue], let count = Int(acceptedCount) {
            if metrics.count != count {
                if let acceptedMetrics = headers[Network.MIMEType.acceptedMetricsLabels.rawValue]?.split(separator: ",") {
                    let sentMetrics = Set(metrics)
                    let acceptedMetrics = Set(acceptedMetrics.map { String($0) })
                    let mismatches = sentMetrics.symmetricDifference(acceptedMetrics)
                    
                    Logger.warning(.network, "Mismatch found for sent metric: \(mismatches). Accepted (\(count)/\(metrics.count))")
                } else {
                    Logger.warning(.network, "Unknown mismatch found for sent metric. Accepted (\(count)/\(metrics.count))")
                }
                
                return false
            }
        }
        
        return true
    }
}

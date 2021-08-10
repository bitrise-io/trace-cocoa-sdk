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
    internal func metrics(with model: Metrics, _ completion: @escaping (Result<(data: Data?, response: HTTPURLResponse?), HTTPNetwork.Error>) -> Void) -> URLSessionDataTask? {
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
        guard let acceptedCount = headers[HTTPNetwork.MIMEType.acceptedMetricsCount.rawValue],
              let count = Int(acceptedCount) else { return false }
        guard let acceptedMetrics = headers[HTTPNetwork.MIMEType.acceptedMetricsLabels.rawValue]?.split(separator: ",") else { return false }
        
        let sent = Set(metrics)
        let accepted = Set(acceptedMetrics.map { String($0) })
        let mismatches = sent.symmetricDifference(accepted)
        
        guard metrics.count != count, !mismatches.isEmpty else { return true }
                    
        Logger.warning(.network, "Mismatch found for sent metric: \(mismatches), Accepted (\(count)/\(metrics.count)).")
        
        return false
    }
}

//
//  DAO.swift
//  Trace
//
//  Created by Shams Ahmed on 23/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// DAO
internal struct DAO {
    
    // MARK: - Property
    
    /// Metric
    internal let metric: MetricDAO
    
    /// Metric
    internal let trace: TraceDAO
    
    // MARK: - Init
    
    internal init(with persistent: Persistent) {
        metric = MetricDAO(with: persistent)
        trace = TraceDAO(with: persistent)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
}

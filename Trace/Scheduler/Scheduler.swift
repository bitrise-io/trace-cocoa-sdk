//
//  Scheduler.swift
//  Trace
//
//  Created by Shams Ahmed on 25/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Scheduler class manages sending data across the network using a custom queue
internal final class Scheduler {
    
    // MARK: - Property
    
    private let traceService: TraceService
    private let metricsService: MetricsService
    private let crashesService: CrashesService
    
    // MARK: - Init
    
    internal init(with network: Networkable) {
        self.traceService = TraceService(network: network)
        self.metricsService = MetricsService(network: network)
        self.crashesService = CrashesService(network: network)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
  
    // MARK: - Schedule
    
    func schedule(_ metrics: Metrics, _ completion: @escaping (Result<Data?, Network.Error>) -> Void) {
        metricsService.metrics(with: metrics, { completion($0) })
    }
    
    func schedule(_ trace: TraceModel, _ completion: @escaping (Result<Data?, Network.Error>) -> Void) {
        traceService.trace(with: trace, { completion($0) })
    }
    
    func schedule(_ crash: Crash, _ completion: @escaping (Result<Data?, Network.Error>) -> Void) {
        crashesService.crash(with: crash, { completion($0) })
    }
}

//
//  CrashesService.swift
//  Trace
//
//  Created by Shams Ahmed on 10/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal struct CrashesService {
    
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
    internal func crash(with model: Crash, _ completion: @escaping (Result<Data?, Network.Error>) -> Void) -> URLSessionDataTask? {
        let router = Router.crash
        let parameters = try? model.dictionary()
        let name = model.title
        let file = model.report
        
        if parameters == nil {
            Logger.error(.crash, "Could not create crash report model")
        }
        
        return network.upload(router, name: name, file: file, parameters: parameters) {
            completion($0)
        }
    }
}

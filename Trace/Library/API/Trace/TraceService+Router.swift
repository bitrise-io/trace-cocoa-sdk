//
//  TraceService+Router.swift
//  Trace
//
//  Created by Shams Ahmed on 29/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension TraceService {
    
    // MARK: - Router
    
    enum Router: Routable {
        case trace(TraceModel)
        
        // MARK: - Property
        
        static var baseURL: URL = Constants.API
        
        var method: Network.Method {
            switch self {
            case .trace: return .post
            }
        }
        
        var path: String {
            switch self {
            case .trace: return "api/v1/trace"
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            // create request
            var url = Router.baseURL
            url.appendPathComponent(path)
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            // add body and settings
            switch self {
            case .trace(let model): request.httpBody = try model.json()
            }
        
            return request
        }
    }
}

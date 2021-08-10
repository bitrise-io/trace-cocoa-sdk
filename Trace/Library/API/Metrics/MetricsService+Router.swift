//
//  MetricsService+Router.swift
//  Trace
//
//  Created by Shams Ahmed on 31/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension MetricsService {
    
    // MARK: - Router
    
    enum Router: Routable {
        case metrics(Metrics)
        
        // MARK: - Property
        
        static var baseURL: URL = Constants.API
        
        var method: HTTPNetwork.Method {
            switch self {
            case .metrics: return .post
            }
        }
        
        var path: String {
            switch self {
            case .metrics: return "api/metrics"
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let headerValue = HTTPNetwork.MIMEType.jsonV1.rawValue
            
            // create request
            var url = Router.baseURL
            url.appendPathComponent(path)
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.setValue(headerValue, forHTTPHeaderField: HTTPNetwork.Header.accept.rawValue)
            request.setValue(headerValue, forHTTPHeaderField: HTTPNetwork.Header.contentType.rawValue)
            
            // add body and settings
            switch self {
            case .metrics(let model): request.httpBody = try model.json()
            }
            
            return request
        }
    }
}

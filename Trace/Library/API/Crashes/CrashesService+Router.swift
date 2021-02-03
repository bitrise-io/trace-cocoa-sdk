//
//  CrashesService+Router.swift
//  Trace
//
//  Created by Shams Ahmed on 10/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension CrashesService {
    
    // MARK: - Router
    
    enum Router: Routable {
        case crash
        
        // MARK: - Property
        
        static var baseURL: URL = Constants.API
        
        var method: Network.Method {
            switch self {
            case .crash: return .post
            }
        }
        
        var path: String {
            switch self {
            case .crash: return "api/v1.0.1/crashes/ios"
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            // create request
            var url = Router.baseURL
            url.appendPathComponent(path)
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            return request
        }
    }
}

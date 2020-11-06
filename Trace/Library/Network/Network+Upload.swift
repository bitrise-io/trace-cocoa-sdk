//
//  Network+Upload.swift
//  Trace
//
//  Created by Shams Ahmed on 11/03/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

internal extension Network {

    // MARK: - Upload

    /// Upload with multi-part form
    @discardableResult
    func upload(_ request: Routable, name: String, file: Data, parameters: [String: Any]? = nil, _ completion: @escaping (Completion) -> Void) -> URLSessionDataTask? {
        // validate url request
        guard var url = try? request.asURLRequest() else {
            Logger.error(.network, "Invalid url request with: \(request.path)")
            
            completion(.failure(.invalidURL))
            
            return nil
        }
        guard !configuration.additionalHeaders.isEmpty else {
            Logger.error(.network, "Request cached as bitrise_configuration.plist file has not been set. Please review getting started guide on https://trace.bitrise.io/o/getting-started")
            
            completion(.failure(.noAuthentication))
            
            return nil
        }

        // add auth
        configuration.additionalHeaders.forEach {
            url.addValue($0.value, forHTTPHeaderField: $0.key.rawValue)
        }
        
        let boundary = "Boundary-" + UUID().uuidString
        
        var body = Data()
        body.append(convertParameters(parameters, using: boundary))
        body.append(convertFile(file, name: name, using: boundary))

        url.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: Header.contentType.rawValue)
        url.httpBody = body
        
        // network async request
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            self?.validate(data, response, error, completion: completion)
        }
        
        // start request
        task.resume()

        return task
    }
    
    // MARK: - Helper
    
    private func convertFile(_ fileData: Data, name: String, using boundary: String) -> Data {
        var data = Data()
        data.appendString("--\(boundary)\r\n")
        
        data.appendString("Content-Disposition: form-data; name=\"report\"\r\n\r\n")
        
        data.append(fileData)
        data.appendString("\r\n")
        data.appendString("--\(boundary)--")

        return data
    }
    
    private func convertParameters(_ parameters: [String: Any]?, using boundary: String) -> Data {
        let separator = "\r\n"
        var data = Data()
        
        parameters?.forEach { key, value in
            data.appendString("--\(boundary)\(separator)")
            data.appendString("Content-Disposition: form-data; name=\"\(key)\"\(separator)")
            data.appendString(separator)
            
            if let string = value as? String {
                data.appendString(string + separator)
            } else if let int = value as? Int {
                data.appendString(String(int) + separator)
            } else if let double = value as? Double {
                data.appendString(String(double) + separator)
            } else {
                Logger.error(.network, "Failed to decode parameter \(key)")
            }
        }
        
        return data
    }
}

//
//  Network+HTTP.swift
//  Trace
//
//  Created by Shams Ahmed on 28/05/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

// MARK: - Enums
internal extension Network {

    // MARK: - Property

    /// Success status codes 200 to 299
    var successStatusCodes: [Int] { return Array(200..<300) }

    /// Client error status codes 400 to 499
    var clientStatusCodes: [Int] { return Array(400..<500) }

    /// Server error status codes 500 to 599
    var serverStatusCodes: [Int] { return Array(500..<600) }
    
    // MARK: - Enum
    
    /// Common HTTP Header
    ///
    /// - authorization: authorization
    /// - userAgent: userAgent
    /// - acceptLanguage: acceptLanguage
    /// - acceptEncoding: acceptEncoding
    /// - apiKey: apiKey
    /// - contentType: contentType
    /// - accept: accept
    enum Header: String {
        /// authorization
        case authorization = "Authorization"
        /// userAgent
        case userAgent = "User-Agent"
        /// acceptLanguage
        case acceptLanguage = "Accept-Language"
        /// acceptEncoding
        case acceptEncoding = "Accept-Encoding"
        /// apiKey
        case apiKey = "x-api-key"
        /// contentType
        case contentType = "Content-Type"
        /// accept
        case accept = "Accept"
        /// installationSource
        case installationSource = "X-Bitrise_sdk_installation"
    }

    /// HTTP Method
    ///
    /// - options: options
    /// - get: get
    /// - head: head
    /// - post: post
    /// - put: put
    /// - patch: path
    /// - delete: delete
    /// - trace: trace
    /// - connect: connect
    enum Method: String {
        /// options
        case options = "OPTIONS"
        /// get
        case get = "GET"
        /// head
        case head = "HEAD"
        /// post
        case post = "POST"
        /// put
        case put = "PUT"
        /// path
        case patch = "PATCH"
        /// delete
        case delete = "DELETE"
        /// trace
        case trace = "TRACE"
        /// connect
        case connect = "CONNECT"
    }
    
    /// Network errors
    ///
    /// - noAuthentication: no authentication
    /// - invalidData: invalid data
    /// - invalidURL: invalid URL
    /// - client: client error
    /// - server: server error
    /// - unknown: unknown error with optional error
    enum Error: Swift.Error {
        /// no authentication
        case noAuthentication
        /// invalidData
        case invalidData
        /// invalidURL
        case invalidURL
        /// client error
        case client
        /// server error
        case server
        /// unknown error
        case unknown(error: Swift.Error?)
    }
    
    /// StatusCode
    ///
    /// - ok: ok
    /// - created: created
    /// - accepted: accepted
    /// - noContent: noContent
    /// - resetContent: resetContent
    /// - movedPermanently: movedPermanently
    /// - found: found
    /// - notModified: notModified
    /// - badRequest: badRequest
    /// - unauthorized: unauthorized
    /// - forbidden: forbidden
    /// - notFound: notFound
    /// - notAcceptable: notAcceptable
    /// - internalServerError: internalServerError
    /// - notImplemented: notImplemented
    /// - badGateway: badGateway
    /// - serviceUnavailable: serviceUnavailable
    /// - gatewayTimeout: gatewayTimeout
    enum StatusCode: Int {
        /// ok
        case ok = 200
        /// created
        case created = 201
        /// accepted
        case accepted = 202
        /// noContent
        case noContent = 204
        /// resetContent
        case resetContent = 205
        /// movedPermanently
        case movedPermanently = 301
        /// found
        case found = 302
        /// notModified
        case notModified = 304
        /// badRequest
        case badRequest = 400
        /// unauthorized
        case unauthorized = 401
        /// forbidden
        case forbidden = 403
        /// notFound
        case notFound = 404
        /// notAcceptable
        case notAcceptable = 406
        /// internalServerError
        case internalServerError = 500
        /// notImplemented
        case notImplemented = 501
        /// badGateway
        case badGateway = 502
        /// serviceUnavailable
        case serviceUnavailable = 503
        /// gatewayTimeout
        case gatewayTimeout = 504
    }
    
    /// MIME type
    ///
    /// - text: text/plain
    /// - html: text/html
    /// - json: application/json
    enum MIMEType: String {
        /// text/plain
        case text = "text/plain"
        /// text/html
        case html = "text/html"
        /// application/json
        case json = "application/json"
    }
}

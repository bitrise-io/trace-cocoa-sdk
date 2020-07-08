//
//  URLStructure.swift
//  Trace
//
//  Created by Shams Ahmed on 22/08/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

/// Helper to format urls to only provide the domain and endpoint details
/// i,e bitrise.io and NOT https://bitrise.io/api/v1/search=xxx
struct URLStructure {
    
    // MARK: - Enum
    
    private enum Banned: String, CaseIterable {
        case json, png, jpg, jpeg, plist, txt, text, zip, mp3, mp4, mov, gif, pdf, tif, raw, svg, css, html, doc, docx, mpeg, qt, js, gz, htm, ico, otf, rtf, xhtml, xml, odt, sql, db, sqlite, pfx, cert, pem, ssl, ts
    }
    
    // MARK: - Property
    
    let url: URL?
    
    // MARK: - Format
    
    func format() -> String? {
        guard var url = url else { return self.url?.absoluteString }
        
        // Patch url when http cannot be found. This stops URLComponents from breaking
        // scheme is disregarded
        if url.scheme == nil, let patchedURL = URL(string: "https://" + url.absoluteString) {
            url = patchedURL
        }
        
        guard let component = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url.absoluteString }
        guard var host = component.host else { return url.absoluteString }
        
        if host.hasPrefix("http://") {
            host.removeFirst(7)
        }
        
        if host.hasPrefix("https://") {
            host.removeFirst(8)
        }
        
        if host.hasPrefix("www.") {
            host.removeFirst(4)
        }
        
        if host.hasPrefix("www1.") {
            host.removeFirst(5)
        }
        
        if host.hasPrefix("www2.") {
            host.removeFirst(5)
        }
        
        if host.hasPrefix("www3.") {
            host.removeFirst(5)
        }
        
        var path = component.path
        
        if Banned.allCases.contains(where: { path.hasSuffix("." + $0.rawValue) }) {
            path = (path as NSString).deletingLastPathComponent
        }
        
        let result = host + path
        
        return result
    }
}

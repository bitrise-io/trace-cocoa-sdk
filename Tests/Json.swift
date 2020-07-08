//
//  Json.swift
//  Trace
//
//  Created by Shams Ahmed on 02/07/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

extension XCTestCase {
    
    // MARK: - Decode
    
    func decode<T: Decodable>(json name: String) -> T {
        let bundle = Bundle(for: CollaterTests.self)
        
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            fatalError("Cannot find json file")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Cannot convert to data format")
        }
        guard let models = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to create data model")
        }
        
        return models
    }
}

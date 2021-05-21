//
//  URLSessionTaskMetricsTests.swift
//  Tests
//
//  Created by Shams Ahmed on 19/05/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class URLSessionTaskMetricsTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        URLSessionTaskMetrics.bitrise_swizzle_methods()
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testTask() {
        let result = URLSessionTaskMetrics.bitrise_swizzle_methods()
        
        switch result {
            case .success: break
            default: break
        }
    }
}

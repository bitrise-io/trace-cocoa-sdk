//
//  JailbrokeTests.swift
//  Trace
//
//  Created by Shams Ahmed on 06/01/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class JailbrokeTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testJailbrokeLogic() {
        let result = UIDevice.current.isJailbroken
        
        XCTAssertFalse(result)
    }
    
    func testDoesntContainPaths() {
        let jailbroke = UIDevice.Jailbroke()
        let result = jailbroke.containsSuspiciousPathsTests
        
        XCTAssertTrue(result)
    }
}

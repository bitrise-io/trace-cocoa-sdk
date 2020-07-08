//
//  FileManagerTests.swift
//  Trace
//
//  Created by Shams Ahmed on 03/06/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class FileManagerTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testReadsDiskSpace() {
        let fileManager = FileManager.default
        
        XCTAssertNotEqual(fileManager.freeDiskSpace, "0")
        XCTAssertNotEqual(fileManager.usedDiskSpace, "0")
        XCTAssertNotEqual(fileManager.totalDiskSpace, "0")
    }
}

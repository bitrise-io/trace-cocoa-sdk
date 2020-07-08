//
//  ViewControllerSwizzledTests2.swift
//  Tests
//
//  Created by Shams Ahmed on 05/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class ViewControllerSwizzledTests2: XCTestCase {
    
    // MARK: - Property
    
    // MARK: - Setup
    
    override func setUp() {
       
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
        
    func testManualCalls_nib() {
        let viewController = TestViewController()
        viewController.awakeFromNib()
        viewController.viewDidAppear(true)
        viewController.viewWillDisappear(true)
        viewController.viewDidDisappear(true)

        XCTAssertNotNil(viewController.metric)
        XCTAssertNotNil(viewController.metric.viewWillDisappear)
        XCTAssertNotNil(viewController.metric.viewDidDisappear)
        XCTAssertGreaterThan(viewController.metric.viewRenderingLatency, 0)
    }
    
    func testManualCalls_coder() {
        let archived = try! NSKeyedArchiver.archivedData(
            withRootObject: TestViewController(),
            requiringSecureCoding: false
        )
        let archiver = try! NSKeyedUnarchiver(forReadingFrom: archived)
        
        let viewController = TestViewController(coder: archiver)!
        viewController.viewDidAppear(true)
        viewController.viewWillDisappear(true)
        viewController.viewDidDisappear(true)
        
        XCTAssertNotNil(viewController.metric)
        XCTAssertNotNil(viewController.metric.initWithCoder)
        XCTAssertGreaterThan(viewController.metric.viewRenderingLatency, 0)
    }
}

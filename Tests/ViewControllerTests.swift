//
//  ViewControllerTests.swift
//  Tests
//
//  Created by Shams Ahmed on 18/05/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import Trace

final class ViewControllerTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        UIViewController.bitrise_swizzle_methods()
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testViewController() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = UIViewController()
        
        XCTAssertNil(viewController.title)
        XCTAssertNotNil(viewController)
    }
    
    func testViewController_noTraceSet() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = UIViewController()
        
        XCTAssertNil(viewController.title)
        XCTAssertNil(viewController.trace)
    }
    
    func testViewController_findCustomTitle_before() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = UIViewController()
        
        XCTAssertNil(viewController.title)
        
        viewController.title = "Test"
        viewController.start()
        
        XCTAssertEqual((viewController.trace?.root.name.value as? String), "Test (UIViewController)")
    }
    
    func testViewController_findCustomTitle_after() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = UIViewController()
        viewController.start()
        
        XCTAssertNil(viewController.title)
        XCTAssertEqual((viewController.trace?.root.name.value as? String), "UIViewController")
        
        viewController.title = "Test"
        
        XCTAssertEqual((viewController.trace?.root.name.value as? String), "Test (UIViewController)")
    }
    
    func testViewController_lifecycle() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = UIViewController()
        
        XCTAssertNil(viewController.title)
        
        viewController.viewDidLoad()
        viewController.viewWillAppear(true)
        viewController.viewWillLayoutSubviews()
        viewController.viewDidLayoutSubviews()
        viewController.viewDidAppear(true)
        
        XCTAssertNotNil(viewController.trace)
        XCTAssertFalse(viewController.trace!.isComplete)
    }
    
    func testViewController_lifecycle_failsafeMode() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = UIViewController()
        
        viewController.viewWillAppear(true)
        
        XCTAssertNotNil(viewController.trace)
        XCTAssertFalse(viewController.trace!.isComplete)
    }
    
    func testViewController_lifecycle_disappear() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = UIViewController()
        
        XCTAssertNil(viewController.title)
        
        viewController.viewDidLoad()
        viewController.viewWillAppear(true)
        viewController.viewWillLayoutSubviews()
        viewController.viewDidLayoutSubviews()
        viewController.viewDidAppear(true)
        sleep(1)
        viewController.viewWillDisappear(true)
        viewController.viewDidDisappear(true)
        
        XCTAssertNil(viewController.trace)
    }
    
    func testViewController_restart() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = UIViewController()
        
        XCTAssertNil(viewController.title)
        
        viewController.viewDidLoad()
        
        let traceId = viewController.trace!.traceId
        
        viewController.restart()
        
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController.trace)
        XCTAssertNotEqual(viewController.trace!.traceId, traceId)
    }
    
    func testViewController_notification() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = UIViewController()
        
        viewController.viewDidLoad()
        
        let traceId = viewController.trace!.traceId
        
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        
        sleep(1)
        
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController.trace)
        XCTAssertNotEqual(viewController.trace!.traceId, traceId)
    }
}

//
//  ViewControllerSwizzledTests.swift
//  Tests
//
//  Created by Shams Ahmed on 04/09/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

class ILClassificationUIExtensionViewController: UIViewController {
    
}

class _TestViewController: UIViewController {
    
}

class TestViewController: UIViewController {
    
}

final class ViewControllerSwizzledTests: XCTestCase {
    
    // MARK: - Property
    
    
    // MARK: - Setup
    
    override func setUp() {
        UIViewController.bitrise_swizzle_methods()
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testViewController_happyFlow() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = TestViewController()
        viewController.perform(#selector(UIViewController.loadView))
        viewController.perform(#selector(UIViewController.viewDidLoad))
        viewController.perform(#selector(UIViewController.viewWillLayoutSubviews))
        viewController.perform(#selector(UIViewController.viewDidLayoutSubviews))
        viewController.perform(#selector(UIViewController.viewWillAppear), with: true)
        viewController.perform(#selector(UIViewController.viewDidAppear), with: true)
        viewController.perform(#selector(UIViewController.viewWillDisappear), with: true)
        viewController.perform(#selector(UIViewController.viewDidDisappear), with: true)
        
        XCTAssertNotNil(viewController.metric)
        XCTAssertNotNil(viewController.metric.loadView)
        XCTAssertNotNil(viewController.metric.viewDidLoad)
        XCTAssertNotNil(viewController.metric.viewWillLayoutSubviews)
        XCTAssertNotNil(viewController.metric.viewDidLayoutSubviews)
        XCTAssertNotNil(viewController.metric.viewWillAppear)
        XCTAssertNotNil(viewController.metric.viewDidAppear)
        
        XCTAssertGreaterThan(viewController.metric.viewRenderingLatency, 0.00001)
    }
    
    func testViewController_memoryWarning() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = TestViewController()
        viewController.perform(#selector(UIViewController.didReceiveMemoryWarning))
        
        XCTAssertNotNil(viewController.metric)
        XCTAssertNotNil(viewController.metric.didReceiveMemoryWarning)
    }
    
    func testViewControllerDoesntTrigger_internalClass() {
        UIViewController.bitrise_swizzle_methods()
        
        let viewController = _TestViewController()
        viewController.perform(#selector(_TestViewController.didReceiveMemoryWarning))

        XCTAssertNotNil(viewController.metric)
        XCTAssertFalse(viewController.metric.observed)
    }

    func testViewControllerDoesntTrigger_bannedClass() {
        UIViewController.bitrise_swizzle_methods()

        let viewController = ILClassificationUIExtensionViewController()
        
        XCTAssertNotNil(viewController.metric)
        
        viewController.metric = UIViewController.Metric()
        
        XCTAssertNotNil(viewController.metric)
        
        viewController.perform(#selector(ILClassificationUIExtensionViewController.didReceiveMemoryWarning))

        XCTAssertNotNil(viewController.metric)
        XCTAssertFalse(viewController.metric.observed)
    }
}

//
//  UIApplicationTests.swift
//  Tests
//
//  Created by Shams Ahmed on 18/05/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class UIApplicationTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testCurrentViewController() {
        let application = UIApplication.shared
        
        XCTAssertNil(application.currentViewController(from: nil))
    }
    
    func testCurrentViewController_viewController() {
        let application = UIApplication.shared
        let viewController = UIViewController()
        
        XCTAssertNotNil(application.currentViewController(from: viewController))
    }
    
    func testCurrentViewController_navigationController() {
        let application = UIApplication.shared
        let viewController = UIViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        
        XCTAssertNotNil(application.currentViewController(from: navigation))
    }
    
    func testCurrentViewController_tabController() {
        let application = UIApplication.shared
        let viewController = UIViewController()
        let tab = UITabBarController()
        
        tab.viewControllers = [viewController]
        
        XCTAssertNotNil(application.currentViewController(from: tab))
    }
    
    func testCurrentViewController_tabController_3_viewcontroller() {
        let application = UIApplication.shared
        let tab = UITabBarController()
        let viewControllers = (1...3).map { _ in UIViewController() }
        
        tab.viewControllers = viewControllers
        
        XCTAssertNotNil(application.currentViewController(from: tab))
    }
    
    func testCurrentViewController_tabController_7_viewcontroller() {
        let application = UIApplication.shared
        let tab = UITabBarController()
        let viewControllers = (1...7).map { _ in UIViewController() }
        
        tab.viewControllers = viewControllers
        tab.selectedIndex = 5
        
        XCTAssertNotNil(application.currentViewController(from: tab))
    }
}

//
//  LoadTests.swift
//  PerformanceTests
//
//  Created by Mukund Agarwal on 22/05/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest

class LoadTests: XCTestCase {
        
    // MARK: - Tests
    
    func testCpuMemoryPerformance_write_10metrics() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            loadObjects(times: 10)
        }
    }

    func testCpuMemoryPerformance_write_100metrics() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            loadObjects(times: 100)
        }
    }
    
    // MARK: - Private methods
    
    private func loadObjects(times: Int) {
        for _ in 1...times {
            let storyboard = UIStoryboard(name: "Main",
                                          bundle: Bundle.main)
            let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            let viewController = navigationController.topViewController!
                   
            UIApplication.shared.windows.first { $0.isKeyWindow }!.rootViewController = viewController
             
            let _ = navigationController.view
            let _ = viewController.view
            
            navigationController.dismiss(animated: false, completion: nil)
        }
    }
    
}

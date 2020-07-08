//
//  ViewSwizzledTests.swift
//  Tests
//
//  Created by Shams Ahmed on 05/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

class _TestView: UIView {
    
}

class NSTestView: UIView {
    
}


class TestView: UIView {
    
}

final class ViewSwizzledTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        UIView.bitrise_swizzle_methods()
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testView_happyFlow() {
        UIView.bitrise_swizzle_methods()
        
        let view = TestView(frame: .zero)
        view.layoutIfNeeded()
        view.perform(#selector(UIView.init(frame:)), with: CGRect.zero)
        view.perform(#selector(UIView.layoutSubviews))
        view.perform(#selector(UIView.draw(_:)), with: CGRect.zero)
        view.perform(#selector(UIView.didMoveToSuperview))
        view.perform(#selector(UIView.didMoveToWindow))
        view.perform(#selector(UIView.removeFromSuperview))
        
        XCTAssertNotNil(view.metric)
        XCTAssertNotNil(view.metric.layoutSubviews)
        XCTAssertNotNil(view.metric.draw)
        XCTAssertNotNil(view.metric.didMoveToSuperview)
        
        XCTAssertGreaterThan(view.metric.duration, 0.00001)
    }
    
    func testView_removeView() {
        UIView.bitrise_swizzle_methods()
        
        let view = TestView(frame: .zero)
        view.layoutIfNeeded()
        view.perform(#selector(UIView.init(frame:)), with: CGRect.zero)
        view.perform(#selector(UIView.didMoveToWindow))
        view.perform(#selector(UIView.removeFromSuperview))
        
        XCTAssertNotNil(view.metric)
        XCTAssertNotNil(view.metric.didMoveToWindow)
        XCTAssertNotNil(view.metric.removeFromSuperview)
    }
    
    func testView_initWithCoder() {
        UIView.bitrise_swizzle_methods()
        
        let archived = try! NSKeyedArchiver.archivedData(
            withRootObject: UIView(),
            requiringSecureCoding: false
        )
        let archiver = try! NSKeyedUnarchiver(forReadingFrom: archived)  
        let view = UIView(coder: archiver)!
        
        XCTAssertNotNil(view.metric)
        XCTAssertNotNil(view.metric.duration)
        XCTAssertNotNil(view.metric.initWithCoder)
    }
}

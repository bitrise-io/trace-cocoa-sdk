//
//  ViewSwizzledTests2.swift
//  Tests
//
//  Created by Shams Ahmed on 12/09/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation

import Foundation
import XCTest
@testable import Trace

final class ViewSwizzledTests2: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        UIView.bitrise_swizzle_methods()
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testView_internalClass() {
        UIView.bitrise_swizzle_methods()
        
        let view = _TestView(frame: .zero)
        view.perform(#selector(UIView.layoutSubviews))
        view.perform(#selector(UIView.draw(_:)), with: CGRect.zero)
        view.perform(#selector(UIView.didMoveToSuperview))
        view.perform(#selector(UIView.didMoveToWindow))
        view.perform(#selector(UIView.removeFromSuperview))
        
        XCTAssertNotNil(view.metric)
        XCTAssertTrue(view.metric.observed)
    }
    
    func testView_bannedClass() {
        UIView.bitrise_swizzle_methods()
        
        let view = NSTestView(frame: .zero)
        view.perform(#selector(UIView.layoutSubviews))
        view.perform(#selector(UIView.draw(_:)), with: CGRect.zero)
        view.perform(#selector(UIView.didMoveToSuperview))
        view.perform(#selector(UIView.didMoveToWindow))
        view.perform(#selector(UIView.removeFromSuperview))
        
        XCTAssertNotNil(view.metric)
        XCTAssertTrue(view.metric.observed)
    }
}

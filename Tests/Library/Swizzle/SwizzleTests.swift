//
//  SwizzleTests.swift
//  Tests
//
//  Created by Shams Ahmed on 24/05/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class SwizzleTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testSwizzlingInstance_method() {
        InstanceMethodExample.bitrise_swizzle_methods()
        
        let example = InstanceMethodExample()
        example.fail()
    }
    
    func testSwizzlingInstance_failsWithOriginalNotFound() {
        let result = InstanceMethodOriginalFailsExample.bitrise_swizzle_methods()
        
        XCTAssertEqual(result, Swizzle.Result.originalMethodNotFound)
    }
    
    func testSwizzlingInstance_failsWithAlternativeNotFound() {
        let result = InstanceMethodAlternativeFailsExample.bitrise_swizzle_methods()
        
        XCTAssertEqual(result, Swizzle.Result.alternativeMethodNotFound)
    }
    
    func testSwizzlingInstance_object() {
        InstanceObjectExample.bitrise_swizzle_methods()
        
        let example = InstanceObjectExample()
        example.fail()
    }
    
    func testSwizzlingClass_method() {
        ClassMethodExample.bitrise_swizzle_methods()
        
        ClassMethodExample.fail()
    }
    
    func testSwizzlingClass_failsOriginalSwap() {
        let result = ClassMethodOriginalFailsExample.bitrise_swizzle_methods()
        
        XCTAssertEqual(result, Swizzle.Result.originalMethodNotFound)
    }
    
    func testSwizzlingClass_failsAlternativeSwap() {
        let result = ClassMethodAlternativeFailsExample.bitrise_swizzle_methods()
        
        XCTAssertEqual(result, Swizzle.Result.alternativeMethodNotFound)
    }
    
    func testSwizzlingClass_object() {
        ClassObjectExample.bitrise_swizzle_methods()
        
        ClassObjectExample.fail()
    }
    
    func testSwizzlingInstance_methodWithMainCall() {
        InstanceMethodCounter.bitrise_swizzle_methods()
        
        let example = InstanceMethodCounter()
        
        XCTAssertEqual(example.counter, 0)
        
        example.addOne()
        
        XCTAssertEqual(example.counter, 11)
    }
}

// MARK: - InstanceMethodExample

@objcMembers
class InstanceMethodExample: NSObject {
    
    // MARK: - Methods
    
    @objc
    dynamic func fail() {
        XCTFail("Swizzing failed")
    }
}

extension InstanceMethodExample: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let original = #selector(fail)
        let alternative = #selector(pass)
        
        return self.swizzleInstanceMethod(original, for: alternative)
    }
    
    // MARK: - Methods
    
    @objc
    func pass() {
        XCTAssert(true, "Swizzing passed")
    }
}

// MARK: - InstanceMethodOriginalFailsExample

@objcMembers
class InstanceMethodOriginalFailsExample: NSObject, Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let original = NSSelectorFromString("test")
        let alternative = #selector(pass)
        
        return self.swizzleInstanceMethod(original, for: alternative)
    }
    
    // MARK: - Methods
    
    @objc
    func pass() {
        XCTAssert(true, "Swizzing passed")
    }
}

// MARK: - InstanceMethodAlternativeFailsExample

@objcMembers
class InstanceMethodAlternativeFailsExample: NSObject {
    
    // MARK: - Methods
    
    @objc
    dynamic func fail() {
        XCTFail("Swizzing failed")
    }
}

extension InstanceMethodAlternativeFailsExample: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let original = #selector(pass)
        let alternative = NSSelectorFromString("test")
        
        return self.swizzleInstanceMethod(original, for: alternative)
    }
    
    // MARK: - Methods
    
    @objc
    func pass() {
        XCTAssert(true, "Swizzing passed")
    }
}

// MARK: - InstanceObjectExample

@objcMembers
class InstanceObjectExample: NSObject {
    
    // MARK: - Methods
    
    @objc
    dynamic func fail() {
        XCTFail("Swizzing failed")
    }
}

extension InstanceObjectExample: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let original = #selector(fail)
        let alternative = #selector(pass)
        let object = Swizzle.Object(class: self, selector: alternative)
        
        return self.swizzleInstanceMethod(original, for: object)
    }
    
    // MARK: - Methods
    
    @objc
    func pass() {
        XCTAssert(true, "Swizzing passed")
    }
}

// MARK: - ClassMethodExample

@objcMembers
class ClassMethodExample: NSObject {
    
    // MARK: - Methods
    
    @objc
    dynamic static func fail() {
        XCTFail("Swizzing failed")
    }
}

extension ClassMethodExample: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let original = #selector(fail)
        let alternative = #selector(pass)
        
        return self.swizzleClassMethod(original, alternativeSelector: alternative)
    }
    
    // MARK: - Methods
    
    @objc
    static func pass() {
        XCTAssert(true, "Swizzing passed")
    }
}

// MARK: - ClassMethodOriginalFailsExample

@objcMembers
class ClassMethodOriginalFailsExample: NSObject, Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let original = NSSelectorFromString("xxx")
        let alternative = #selector(pass)
        
        return self.swizzleClassMethod(original, alternativeSelector: alternative)
    }
    
    // MARK: - Methods
    
    @objc
    static func pass() {
        XCTFail("wrong method call")
    }
}

// MARK: - ClassMethodAlternativeFailsExample

@objcMembers
class ClassMethodAlternativeFailsExample: NSObject, Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let original = #selector(pass)
        let alternative = NSSelectorFromString("xxx")
        
        return self.swizzleClassMethod(original, alternativeSelector: alternative)
    }
    
    // MARK: - Methods
    
    @objc
    static func pass() {
        XCTFail("wrong method call")
    }
}


// MARK: - ClassObjectExample

@objcMembers
class ClassObjectExample: NSObject {
    
    // MARK: - Methods
    
    @objc
    dynamic static func fail() {
        XCTFail("Swizzing failed")
    }
}

extension ClassObjectExample: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let original = #selector(fail)
        let alternative = #selector(pass)
        let object = Swizzle.Object(class: self, selector: alternative)
        
        return self.swizzleClassMethod(original, for: object)
    }
    
    // MARK: - Methods
    
    @objc
    static func pass() {
        XCTAssert(true, "Swizzing passed")
    }
}

// MARK: - InstanceMethodCounter

@objcMembers
class InstanceMethodCounter: NSObject {
    
    var counter = 0
    
    // MARK: - Methods
    
    @objc
    dynamic func addTen() {
        counter += 10
        
        self.addTen()
    }
}

extension InstanceMethodCounter: Swizzled {
    
    // MARK: - Swizzled
    
    @discardableResult
    static func bitrise_swizzle_methods() -> Swizzle.Result {
        let original = #selector(addOne)
        let alternative = #selector(addTen)
        
        return self.swizzleInstanceMethod(original, for: alternative)
    }
    
    // MARK: - Methods
    
    @objc
    func addOne() {
        counter += 1
    }
}

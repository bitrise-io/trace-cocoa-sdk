//
//  BitriseConfigurationInteractorTests.swift
//  Trace
//
//  Created by Shams Ahmed on 19/07/2019.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class BitriseConfigurationInteractorTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testBundle() {
        let bundle = Bundle(for: BitriseConfigurationInteractorTests.self)
       
        XCTAssertNotNil(bundle)
    }
    
    func testBundleFindConfiguration() {
        let bundle = Bundle(for: BitriseConfigurationInteractorTests.self)
        let file = bundle.path(forResource: "bitrise_configuration", ofType: "plist")
        
        XCTAssertNotNil(file)
    }
    
    func testConfiguration() {
        let bundle = Bundle(for: BitriseConfigurationInteractorTests.self)
        
        do {
            let interactor = try BitriseConfigurationInteractor(with: bundle)
            
            XCTAssertNotNil(interactor)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testConfigurationModel() {
        let bundle = Bundle(for: BitriseConfigurationInteractorTests.self)
        
        do {
            let interactor = try BitriseConfigurationInteractor(with: bundle)
            let model = interactor.model
            
            XCTAssertNotNil(model)
            XCTAssertNotNil(model.token)
            XCTAssertFalse(model.token.isEmpty)
            XCTAssertNotNil(model.environment)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testConfigurationModel_noURL() {
        let bundle = Bundle(for: BitriseConfigurationInteractorTests.self)
        let url = bundle.url(forResource: "bitrise_configuration_noURL", withExtension: "plist")!
        
        do {
            let data = try Data(contentsOf: url)
            let model = try PropertyListDecoder().decode(BitriseConfiguration.self, from: data)
            
            XCTAssertNotNil(model)
            XCTAssertNotNil(model.token)
            XCTAssertFalse(model.token.isEmpty)
            XCTAssertNil(model.environment)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testConfiguration_canFail() {
        let bundle = Bundle()
        
        do {
            _ = try BitriseConfigurationInteractor(with: bundle)
            
            XCTFail("Test should fail when wrong bundle is used")
        } catch let error {
            XCTAssertNotNil(error)
        }
    }
}

//
//  URLStructureTests.swift
//  Tests
//
//  Created by Shams Ahmed on 03/07/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import Foundation
import XCTest
@testable import Trace

final class URLStructureTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testBitrise() {
        let url = URL(string: "https://www.api.bitrise.io/v1/metric")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("http"))
        XCTAssertEqual(formatted!, "api.bitrise.io/v1/metric")
    }
    
    func testConflictSuffix() {
        let url = URL(string: "https://www.bitrise.io/searchtext")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("http"))
        XCTAssertEqual(formatted!, "bitrise.io/searchtext")
    }
    
    func testRemoveHTTP() {
        let url = URL(string: "https://www.bitrise.io")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("http"))
        XCTAssertEqual(formatted!, "bitrise.io")
    }
    
    func testRemoveWWW() {
        let url = URL(string: "https://www.bitrise.io")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertFalse(formatted!.contains("https://"))
        XCTAssertFalse(formatted!.contains("http://"))
        XCTAssertEqual(formatted!, "bitrise.io")
    }
    
    func testRemoveJSONFile() {
        let url = URL(string: "www.bitrise.io/comments/hfkxg8.json")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "bitrise.io/comments")
    }
    
    func testRemovePNGFile1() {
        let url = URL(string: "external-preview.bitrise.io/sGAfp.png")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "external-preview.bitrise.io/")
    }
    
    func testRemovePNGFile2() {
        let url = URL(string: "preview.bitrise.io/fzsdl1751.png")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "preview.bitrise.io/")
    }
    
    func testRemoveTSFile() {
        let url = URL(string: "v.bitrise.io/0zu1751/HLS_AUDIO_160.ts")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "v.bitrise.io/0zu1751")
    }
    
    func testRemoveMP3File() {
        let url = URL(string: "http://www.bitrise.io/path/to/file.mp3")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "bitrise.io/path/to")
    }
    
    func testSubdomain() {
        let url = URL(string: "http://www.blogs.bitrise.io/article.html")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "blogs.bitrise.io/")
    }
    
    func testQueryString1() {
        let url = URL(string: "https://bitrise.io/over/there?name=bitbot")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "bitrise.io/over/there")
    }
    
    func testQueryString2() {
        let url = URL(string: "https://bitrise.io/path/to/page?name=bitbot&color=purple")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "bitrise.io/path/to/page")
    }
    
    func testAnchorHashtag() {
        let url = URL(string: "https://bitrise.io/path/to/page?name=bitbot&color=purple#bots")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "bitrise.io/path/to/page")
    }
    
    func testFragments() {
        let url = URL(string: "http://bitrise.io/page.html?q=1#param1=foo;param2=bar")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(structure)
        XCTAssertNotNil(formatted)
        
        XCTAssertFalse(formatted!.isEmpty)
        XCTAssertFalse(formatted!.contains("www"))
        XCTAssertFalse(formatted!.contains("WWW"))
        XCTAssertEqual(formatted!, "bitrise.io/")
    }
    
    func testSubdomainWWW1() {
        let url = URL(string: "http://www1.bitrise.io/page.html")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertFalse(formatted!.contains("www1"))
        XCTAssertFalse(formatted!.contains("WWW1"))
        XCTAssertEqual(formatted!, "bitrise.io/")
    }
    
    func testSubdomainWWW4() {
        let url = URL(string: "http://www1.bitrise.io/page.html")
        let structure = URLStructure(url: url)
        let formatted = structure.format()
        
        XCTAssertFalse(formatted!.contains("www4"))
        XCTAssertFalse(formatted!.contains("WWW4"))
        XCTAssertEqual(formatted!, "bitrise.io/")
    }
}

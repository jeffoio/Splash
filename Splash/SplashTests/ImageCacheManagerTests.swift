//
//  ImageCacheManagerTests.swift
//  SplashTests
//
//  Created by TakHyun Jung on 2022/01/24.
//

import XCTest

class ImageCacheManagerTests: XCTestCase {
    private var cache: ImageCache!
    
    override func setUp() {
        super.setUp()
        self.cache = ImageCache()
    }
    
    override func tearDown() {
        super.tearDown()
        self.cache.removeAll()
        self.cache = nil
    }

    func testLoadData() {
        let testData = Data(repeating: 1, count: 10)
        
        self.cache.save(testData, key: "TestData")
        
        let loadData = self.cache.load(key: "TestData")
        
        XCTAssertEqual(testData, loadData)
    }
    
    func testCacheRemove() {
        let testData = Data(repeating: 1, count: 10)
        
        self.cache.save(testData, key: "TestData")
        self.cache.removeAll()
        
        XCTAssertNil(self.cache.load(key: "TestData"))
    }
}

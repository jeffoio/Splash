//
//  PhotoLoaderTests.swift
//  SplashTests
//
//  Created by TakHyun Jung on 2022/01/24.
//

import XCTest

class PhotoLoaderTests: XCTestCase {
    private let testURL =  URL(string: "https://images.unsplash.com/photo-1639570478578-d8ccf810ea80?crop=entropy&cs=srgb&fm=jpg&ixid=MnwyODczMTV8MHwxfHRvcGljfHxibzhqUUtUYUUwWXx8fHx8Mnx8MTY0MTM1Mzg1MQ&ixlib=rb-1.2.1&q=85")!
    
    func testPhotoLoad() {
        let imageExpectation = XCTestExpectation(description: "ImageDownLoad")
        
        PhotoLoader.shared.load(url: testURL, id: "TestImage", indexPath: IndexPath(item: 1, section: 1)) { data in
            imageExpectation.fulfill()
        }
        
        wait(for: [imageExpectation], timeout: 5.0)
    }
    
    func testCacnelPhoto() {
        PhotoLoader.shared.removeCache()
        
        PhotoLoader.shared.load(url: testURL, id: "TestImage", indexPath: IndexPath(item: 0, section: 0)) { data in
            sleep(3)
            XCTFail()
        }
        
        PhotoLoader.shared.cancelOperation(IndexPath(item: 0, section: 0))
    }
}

//
//  HomeViewModelTests.swift
//  HomeViewModelTests
//
//  Created by TakHyun Jung on 2022/01/24.
//

import XCTest

class HomeViewModelTests: XCTestCase {
    private var homeViewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        let topicService = TransferService(networkService: NetworkService())
        let topicPhotoRepository = TopicPhotoInformationRepository(service: topicService)
        let topicPhotoUsecase = TopicPhotoInformationUsecase(repository: topicPhotoRepository)
        self.homeViewModel = HomeViewModel(usecase: topicPhotoUsecase)
    }
    
    override func tearDown() {
        super.tearDown()
        self.homeViewModel = nil
    }
    
    func testPhotoBind() {
        let testPhoto = [PhotoInformation(id: "1,", desctiption: "",
                                     urls: URLs(raw: "", full: "", small: "", thumb: ""),
                                     user: User(name: "test"))]
        
        self.homeViewModel.photos.observe(on: self) { photos in
            XCTAssertEqual(testPhoto, photos)
        }
        self.homeViewModel.photos.value.append(contentsOf: testPhoto)
    }
    
    func testTopicUpdate() {
        let updatedTopic = Topic.travel
        
        self.homeViewModel.update(updatedTopic)
        
        XCTAssertEqual(updatedTopic, self.homeViewModel.currentTopic)
    }
}

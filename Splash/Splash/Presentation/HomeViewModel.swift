//
//  HomeViewModel.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/04.
//

import Foundation

protocol PhotoInformationUsecaseInterface {
    func fetch(topic: Topic, page: Int ,completion: @escaping (Result<[PhotoInformation], Error>) -> Void)
}

final class HomeViewModel {
    private let usecase: PhotoInformationUsecaseInterface
    private var currentTopic: Topic
    private var page: Int
    private(set) var photos: Observable<[PhotoInformation]>
    
    init(usecase: PhotoInformationUsecaseInterface) {
        self.usecase = usecase
        self.currentTopic = .holidays
        self.page = 1
        self.photos = Observable([])
    }
    
    func fetch() {
        self.usecase.fetch(topic: self.currentTopic, page: page) { result in
            switch result {
            case .success(let informations):
                self.photos.value.append(contentsOf: informations)
                self.page += 1
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func update(_ topic: Topic) {
        guard self.currentTopic != topic else { return }
        self.currentTopic = topic
        self.page = 1
        self.fetch()
    }
}

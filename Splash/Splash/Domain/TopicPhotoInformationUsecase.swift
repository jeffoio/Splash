//
//  TopicPhotoInformationUsecase.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/05.
//

import Foundation

protocol TopicPhotoInformationRepositoryInterface {
    func fetch(topic: Topic, page: Int ,completion: @escaping (Result<[PhotoInformation], Error>) -> Void)
}

final class TopicPhotoInformationUsecase: TopicPhotoInformationUsecaseInterface {
    private let repository: TopicPhotoInformationRepositoryInterface
    
    init(repository: TopicPhotoInformationRepositoryInterface) {
        self.repository = repository
    }
    
    func fetch(topic: Topic, page: Int ,completion: @escaping (Result<[PhotoInformation], Error>) -> Void) {
        self.repository.fetch(topic: topic, page: page) { result in
            switch result {
            case .success(let informations):
                completion(.success(informations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

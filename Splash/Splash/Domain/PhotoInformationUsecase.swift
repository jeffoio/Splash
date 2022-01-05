//
//  PhotoInformationUsecase.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/05.
//

import Foundation

protocol PhotoInformationRepositoryInterface {
    func fetch(topic: Topic, page: Int ,completion: @escaping (Result<[PhotoInformation], Error>) -> Void)
}

final class PhotoInformationUsecase: PhotoInformationUsecaseInterface {
    private let repository: PhotoInformationRepositoryInterface
    
    init(repository: PhotoInformationRepositoryInterface) {
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

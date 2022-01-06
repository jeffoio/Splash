//
//  TopicPhotoInformationRepository.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/05.
//

import Foundation

final class TopicPhotoInformationRepository: TopicPhotoInformationRepositoryInterface {
    private let service: TransferService
    
    init(service: TransferService) {
        self.service = service
    }
    
    func fetch(topic: Topic, page: Int ,completion: @escaping (Result<[PhotoInformation], Error>) -> Void) {
        let endpoint = EndpointFactory.make(topic: topic, page: page)
        self.service.resume(endpoint: endpoint) { (result: Result<[PhotoInformation], TransferError>) in
            switch result {
            case .success(let informations):
                completion(.success(informations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//
//  PhotoInformationRepository.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/05.
//

import Foundation

protocol Transferable {
    func resume<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, TransferError>) -> Void)
}

final class PhotoInformationRepository: PhotoInformationRepositoryInterface {
    private let service: Transferable
    
    init(service: Transferable) {
        self.service = service
    }
    
    func fetch(topic: Topic, page: Int ,completion: @escaping (Result<[PhotoInformation], Error>) -> Void) {
        let endpoint = Endpoint(urlString: SplashEndpoint.topic(topic).url,
                                headers: ["Authorization": "Client-ID \(Secrets.clientID)"],
                                urlParameters: ["page": "\(page)", "per_page": "30"])
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

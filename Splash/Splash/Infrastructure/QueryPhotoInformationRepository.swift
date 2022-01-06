//
//  QueryPhotoInformationRepository.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import Foundation

final class QueryPhotoInformationRepository: QueryPhotoInformationRepositoryInterface {
    private let service: TransferService
    
    init(service: TransferService) {
        self.service = service
    }
    
    func query(query: String, page: Int, completion: @escaping (Result<[PhotoInformation], Error>) -> Void) {
        let endpoint = EndpointFactory.make(query: query, page: page)
        self.service.resume(endpoint: endpoint) { (result: Result<QueryResults, TransferError>) in
            switch result {
            case .success(let queryResult):
                completion(.success(queryResult.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

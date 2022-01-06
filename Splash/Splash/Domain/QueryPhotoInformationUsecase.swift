//
//  QueryPhotoInformationUsecase.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import Foundation

protocol QueryPhotoInformationRepositoryInterface {
    func query(query: String, page: Int, completion: @escaping (Result<[PhotoInformation], Error>) -> Void)
}

final class QueryPhotoInformationUsecase: QueryPhotoInformationUsecaseInterface {
    private let repository: QueryPhotoInformationRepositoryInterface
    
    init(repository: QueryPhotoInformationRepositoryInterface) {
        self.repository = repository
    }
    
    func query(query: String, page: Int, completion: @escaping (Result<[PhotoInformation], Error>) -> Void) {
        self.repository.query(query: query, page: page) { result in
            switch result {
            case .success(let informations):
                completion(.success(informations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

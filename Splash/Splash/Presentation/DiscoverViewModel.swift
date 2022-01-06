//
//  DiscoverViewModel.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/05.
//

import Foundation

protocol QueryPhotoInformationUsecaseInterface {
    func query(query: String, page: Int, completion: @escaping (Result<[PhotoInformation], Error>) -> Void)
}

final class DiscoverViewModel {
    private let usecase: QueryPhotoInformationUsecaseInterface
    private var queryString: String
    private var page: Int
    private(set) var photos: Observable<[PhotoInformation]>
    
    init(usecase: QueryPhotoInformationUsecaseInterface) {
        self.usecase = usecase
        self.queryString = ""
        self.page = 1
        self.photos = Observable([])
    }

    func query() {
        self.usecase.query(query: self.queryString, page: self.page) { result in
            switch result {
            case .success(let informations):
                self.photos.value.append(contentsOf: informations)
                self.page += 1
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func update(_ query: String) {
        guard self.queryString != query else { return }
        self.photos.value = []
        self.queryString = query
        self.page = 1
        self.query()
    }
}

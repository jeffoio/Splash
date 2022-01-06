//
//  PhotoLoader.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import Foundation

final class PhotoLoader {
    static let shared = PhotoLoader()
    
    private let cache = ImageCache()
    
    private init() { }
    
    func download(url: URL, id: String, completion: @escaping (Data) -> Void) -> Cancelable? {
        if let cachedData = self.cache.load(key: id) {
            completion(cachedData)
            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            self.cache.save(data, key: id)
            completion(data)
        }
        task.resume()
        return task
    }
}

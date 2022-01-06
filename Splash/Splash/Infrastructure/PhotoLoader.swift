//
//  PhotoLoader.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import Foundation
import UIKit

final class PhotoLoader {
    static let shared = PhotoLoader()
    
    private let cache = ImageCache()
    private let queue = OperationQueue()
    private let downQueue = OperationQueue()
    private var operations: [IndexPath: Operation] = [:]
    
    private init() { }
    
    func load(url: URL, id: String, indexPath: IndexPath, completion: @escaping (Data) -> Void) {
        if let cachedData = self.cache.load(key: id) {
            completion(cachedData)
            return
        }
        
        let imageOperation = ImageOperation(url: url) { [weak self] data in
            self?.cache.save(data, key: id)
            completion(data)
        }
        self.operations[indexPath] = imageOperation
        self.queue.addOperation(imageOperation)
    }
    
    func downLoad(url: URL) {
        let imageOperation = ImageOperation(url: url) {  data in
            guard let image = UIImage(data: data) else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        self.downQueue.addOperation(imageOperation)
    }
    
    func cancelOperation(_ indexPath: IndexPath) {
        self.operations[indexPath]?.cancel()
    }
    
    func cancelAllOperation() {
        self.operations.forEach { $0.value.cancel() }
        self.operations = [:]
    }
}

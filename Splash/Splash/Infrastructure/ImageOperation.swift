//
//  ImageOperation.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/07.
//

import Foundation

final class ImageOperation: AsyncOperation {
    private var task: URLSessionDataTask?
    private let url: URL
    private let completion: (Data) -> Void
    
    init(url: URL, completion: @escaping (Data) -> Void) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        self.task = URLSession.shared.dataTask(with: self.url) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }
            self.completion(data)
            self.state = .finished
        }
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
}

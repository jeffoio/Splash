//
//  Endpoint.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/04.
//

import Foundation

enum EndpointError: Error {
    case invalidURL
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"

    var string: String {
        return self.rawValue
    }
}

struct Endpoint {
    private let urlString: String
    private let method: HttpMethod
    private let headers: [String: String]
    private let urlParameters: [String: String]

    init(urlString: String, method: HttpMethod = .get, headers: [String: String], urlParameters: [String: String]) {
        self.urlString = urlString
        self.method = method
        self.headers = headers
        self.urlParameters = urlParameters
    }

    func urlRequest() throws -> URLRequest {
        guard let url = self.url() else { throw EndpointError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method.string
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

    private func url() -> URL? {
        var urlComponents = URLComponents(string: self.urlString)
        urlComponents?.queryItems = urlParameters.map { URLQueryItem(name: $0.key, value: $0.value)}
        return urlComponents?.url
    }
}

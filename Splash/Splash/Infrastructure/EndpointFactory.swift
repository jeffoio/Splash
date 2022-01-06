//
//  EndpointFactory.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/05.
//

import Foundation

enum EndpointFactory {
    static private let headers = ["Authorization": "Client-ID \(Secrets.clientID)"]

    static func make(query: String, page: Int, perPage: Int = 30) -> Endpoint {
        return Endpoint(urlString: SplashEndpoint.search.url,
                        headers: Self.headers,
                        urlParameters: ["page": "\(page)", "per_page": "\(perPage)", "query": query])
    }

    static func make(topic: Topic, page: Int, perPage: Int = 30) -> Endpoint {
        return Endpoint(urlString: SplashEndpoint.topic(topic).url,
                        headers: Self.headers,
                        urlParameters: ["page": "\(page)", "per_page": "\(perPage)"])
    }
}

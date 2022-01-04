//
//  SplashEndpoint.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/04.
//

import Foundation

enum SplashEndpoint {
    static private let baseURL = "https://api.unsplash.com/"

    case search
    case topic(Topic)

    var url: String {
        switch self {
        case .search:
            return Self.baseURL + "search/photos"
        case .topic(let topic):
            return Self.baseURL + "topics/\(topic.string)/photos"
        }
    }
}

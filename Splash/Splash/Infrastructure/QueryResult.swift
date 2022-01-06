//
//  QueryResult.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import Foundation

struct QueryResults: Codable {
    var total: Int
    var results: [PhotoInformation]
}

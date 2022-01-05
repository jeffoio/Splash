//
//  Photo.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/04.
//

import Foundation

struct Photo: Codable, Hashable {
    var id: String
    var desctiption: String?
    var urls: URLs
    var user: User
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

struct URLs: Codable {
    var raw: String
    var full: String
    var small: String
    var thumb: String
}

struct User: Codable {
    var name: String
}

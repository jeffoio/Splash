//
//  Topic.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/04.
//

import Foundation

enum Topic: String, CaseIterable {
    case editorial
    case following
    case blockchain
    case wallpapers
    case architecture
    case experimental
    case nature
    case fashion
    case film
    case people

    var string: String {
        return self.rawValue
    }
}

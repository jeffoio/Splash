//
//  Topic.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/04.
//

import Foundation

enum Topic: String, CaseIterable {
    case holidays
    case blockchain
    case wallpapers
    case architecture
    case experimental
    case nature
    case fashion
    case film
    case people
    case travel
    case history

    var string: String {
        return self.rawValue
    }
    var title: String {
        return self.rawValue.capitalizingFirstLetter()
    }
}

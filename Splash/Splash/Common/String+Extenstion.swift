//
//  String+Extenstion.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/07.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

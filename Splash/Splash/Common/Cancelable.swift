//
//  Cancelable.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/07.
//

import Foundation

protocol Cancelable {
    func downloadCancel()
}

extension URLSessionDataTask: Cancelable {
    func downloadCancel() {
        self.cancel()
    }
}

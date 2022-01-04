//
//  Secrets.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/04.
//

import Foundation

enum Secrets {
    static let clientID = Secrets.environmentVariable(named: "UNSPLASH_CLIENT_ID") ?? ""
    static let clientSecret = Secrets.environmentVariable(named: "UNSPLASH_CLIENT_SECRET") ?? ""

    private static func environmentVariable(named: String) -> String? {
        return ProcessInfo.processInfo.environment[named]
    }
}

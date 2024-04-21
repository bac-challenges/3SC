//
//  Stat.swift
//  Pokemon
//
//  Created by emile on 20/04/2024.
//

import Foundation

struct Stat: Codable {
    let name: String
    let value: Int
}

#if DEBUG
extension Stat {
    static let mockItems: [Stat]  = Array(count: 5) { index in
        Stat(name: "Mock Stat Item \(index)", value: Int.random(in: 1..<100))
    }
}
#endif

//
//  Pokemon.swift
//  Pokemon
//
//  Created by emile on 20/04/2024.
//

import Foundation

struct Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    let stats: [Stat]
}

#if DEBUG
extension Pokemon {
    static let mockItems: [Pokemon] = Array(count: 15) { index in
        Pokemon(id: index, name: "Pokemon \(index)", stats: Stat.mockItems)
    }
}
#endif
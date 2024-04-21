//
//  Stat.swift
//  Pokemon
//
//  Created by emile on 20/04/2024.
//

import Foundation

struct Stat: Codable, Identifiable {
    var id = UUID()
    let name: String
    let value: Int
    let effort: Int
}

#if DEBUG
extension Stat {
    static let mockItems: [Stat]  = Array(count: 5) { index in
        Stat(name: "Stat \(index)", 
             value: Int.random(in: 1..<100),
             effort: Int.random(in: 1..<10))
    }
}
#endif

//
//  Service.swift
//  Pokemon
//
//  Created by emile on 20/04/2024.
//

import Foundation

struct Service {
    func get() async throws -> [String] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([String].self, from: data)
    }
}

//
//  Pokemon
//
//  Created by emile on 23/04/2024.
//

import SwiftUI

@main
struct PokemonApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonList()
        }
    }
}


/**
 * View
 */

// View/PokemonList.swift
struct PokemonList: View {
    
    @State private var items: [Pokemon] = []
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationSplitView {
            List(searchResults, id:\.self) { item in
                NavigationLink {
                    PokemonDetail(item: item)
                } label: {
                    PokemonRow(item: item)
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Pokemons")
            .searchable(text: $searchText)
        } detail: {
            Text("Please select a Pokemon")
        }
        .navigationSplitViewStyle(.balanced)
        .task {
            do {
                items = try await Pokemon.all
            } catch {
                print(error)
            }
        }
    }
    
    var searchResults: [Pokemon] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.contains(searchText.lowercased()) }
        }
    }
}

// View/PokemonRow.swift
private struct PokemonRow: View {
    
    var item: Pokemon
    
    var body: some View {
        HStack {
            ImageView(imageURI: item.sprite, size: 50)
            TextView(text: item.name)
        }
    }
}

// View/PokemonDetail.swift
private struct PokemonDetail: View {
    
    let item: Pokemon
    
    @State private var items: [Pokemon.Stat] = []
    
    var body: some View {
        VStack(spacing: 0) {
            
            ImageView(imageURI: item.sprite, size: 250)
            
            Text(item.name)
                .font(.custom("Helvetica",
                              size: 36,
                              relativeTo: .headline))
            
            List(items, id:\.self) { item in
                StatView(item: item)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .task {
            do {
                items = try await Pokemon.stats(name: item.name)
            } catch {
                print(error)
            }
        }
    }
}

// View/StatView.swift
private struct StatView: View {
    
    let item: Pokemon.Stat
    
    var body: some View {
        HStack() {
            TextView(text: "\(item.name): \(item.value)")
            Spacer()
            TextView(text: "E: \(item.effort)")
        }
    }
}

// View/ImageView.swift
private struct ImageView: View {
    
    let imageURI: String
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: imageURI)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
        .frame(width: size, height: size)
    }
}

// View/TextView.swift
struct TextView: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Helvetica",
                          size: 24,
                          relativeTo: .title2))
    }
}


/**
 * Model
 */

// Model/Wrapper.swift
struct Wrapper: Decodable {
    let results: [Pokemon]
}

// Model/Pokemon.swift
struct Pokemon: Decodable, Hashable {
    
    struct Stat: Codable, Hashable {
        let name: String
        let value: Int
        let effort: Int
    }
    
    let name: String
    let url: String?
    let stats: [Stat]?
}

// Sprite
extension Pokemon {
    var sprite: String {
        var id = url?.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon/", with: "")
        id = id?.replacingOccurrences(of: "/", with: "")
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id ?? "0").png"
    }
}

// Networking
extension Pokemon {
    static var all: [Pokemon] {
        get async throws {
            let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
            return wrapper.results
        }
    }
    
    static func stats(name: String) async throws -> [Stat] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Pokemon.self, from: data).stats ?? []
    }
}


/**
 * Preview
 */

#if DEBUG
#Preview {
    PokemonList()
}
#endif

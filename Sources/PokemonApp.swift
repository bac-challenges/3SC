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
            List(searchResults) { item in
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
        .accentColor(.black)
        .task {
            items = Pokemon.mockItems
        }
    }
    
    var searchResults: [Pokemon] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.contains(searchText) }
        }
    }
}

// View/PokemonRow.swift
private struct PokemonRow: View {
    
    var item: Pokemon
    
    var body: some View {
        HStack {
            ImageView(imageURI: item.image, size: 50)
            TextView(text: item.name)
        }
    }
}

// View/PokemonDetail.swift
private struct PokemonDetail: View {
    
    let item: Pokemon
    
    var body: some View {
        VStack(spacing: 0) {
            
            ImageView(imageURI: item.image, size: 250)
            
            Text(item.name)
                .font(.custom("Helvetica",
                              size: 36,
                              relativeTo: .headline))
            
            List(item.stats) { item in
                StatView(item: item)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

// View/StatView.swift
private struct StatView: View {
    
    let item: Stat
    
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
    
    var imageURI: String
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

// Model/Pokemon.swift
struct Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    let stats: [Stat]
    var image: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }
}

// Model/Stat.swift
struct Stat: Codable, Identifiable {
    var id = UUID()
    let name: String
    let value: Int
    let effort: Int
}


/**
 * Networking
 */

// Service/Service.swift
struct Service {
    func get() async throws -> [String] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([String].self, from: data)
    }
}


/**
 * Utils
 */

#if DEBUG
#Preview {
    PokemonList()
}

extension Pokemon {
    static let mockItems: [Pokemon] = Array(count: 15) { index in
        Pokemon(id: index, name: "Pokemon \(index)", stats: Stat.mockItems)
    }
}

extension Stat {
    static let mockItems: [Stat]  = Array(count: 5) { index in
        Stat(name: "Stat \(index)",
             value: Int.random(in: 1..<100),
             effort: Int.random(in: 1..<10))
    }
}

extension Array {
    public init(count: Int, createElement: (Int) -> Element) {
        self = (0 ..< count).map { index in createElement(index) }
    }
}

#endif

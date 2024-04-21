//
//  ListView.swift
//  Pokemon
//
//  Created by emile on 20/04/2024.
//

import SwiftUI

struct ListView: View {
    
    private let baseImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/####.png"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Pokemon.mockItems) { item in
                    ListViewRow(
                        imagePath: baseImage.replacingOccurrences(of: "####", with: String(item.id)),
                        itemTitle: item.name
                    )
                }
                .navigationTitle("Pokemons")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

private struct ListViewRow: View {
    
    let imagePath: String
    let itemTitle: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imagePath)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.red
            }
            .frame(width: 50, height: 50)
            Text(itemTitle).font(.title2)
        }
    }
}

#if DEBUG
#Preview {
    ListView()
}
#endif

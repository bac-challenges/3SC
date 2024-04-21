//
//  ListView.swift
//  Pokemon
//
//  Created by emile on 20/04/2024.
//

import SwiftUI

struct ListView: View {
    
    @Bindable 
    var store: Store
    
    @State 
    private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List(searchResults) { item in
                NavigationLink {
                    ListRowDetail(item: item)
                        .navigationTitle(item.name)
                } label: {
                    ListRow(item: item)
                }
            }
            .navigationTitle("Pokemons")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [Pokemon] {
        if searchText.isEmpty {
            return store.items
        } else {
            return store.items.filter { $0.name.contains(searchText) }
        }
    }
}

private struct ListRow: View {
    
    @State
    var item: Pokemon
    
    var body: some View {
        HStack {

            PokemonImage(imageURI: item.image, size: 50)
            
            Text(item.name)
                .font(.custom("Helvetica", size: 24, relativeTo: .title2))
        }
    }
}

private struct ListRowDetail: View {
    
    let item: Pokemon
    
    var body: some View {
        VStack {

            PokemonImage(imageURI: item.image, size: 250)
            
            HStack() {
                Text("Stats:")
                    .font(.custom("Helvetica", size: 24, relativeTo: .title3))
                Spacer()
                Text("65")
                    .font(.custom("Helvetica", size: 24, relativeTo: .title3))
            }
            .padding(20)
            
            Spacer()
        }
    }
}

private struct PokemonImage: View {

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


#if DEBUG
#Preview {
    ListView(store: Store())
}
#endif

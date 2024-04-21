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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.items) { item in
                    ListViewRow(item: item)
                }
                .navigationTitle("Pokemons")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

private struct ListViewRow: View {
    
    let item: Pokemon
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.red
            }
            .frame(width: 50, height: 50)
            
            Text(item.name).font(.title2)
        }
    }
}

#if DEBUG
#Preview {
    ListView(store: Store())
}
#endif

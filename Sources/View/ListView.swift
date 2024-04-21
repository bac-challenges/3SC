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
                } label: {
                    ListRow(item: item)
                }
            }
            .navigationTitle("Pokemons")
        }
        .accentColor(.black)
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

    var item: Pokemon
    
    var body: some View {
        HStack {
            ImageView(imageURI: item.image, size: 50)
            TextView(text: item.name)
        }
    }
}

private struct ListRowDetail: View {
    
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

struct TextView: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Helvetica",
                          size: 24,
                          relativeTo: .title2))
    }
}


#if DEBUG
#Preview {
    ListView(store: Store())
}
#endif

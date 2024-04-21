//
//  Store.swift
//  Pokemon
//
//  Created by emile on 20/04/2024.
//

import Foundation
import SwiftUI

@Observable
class Store {
    var items: [Pokemon] = Pokemon.mockItems
}

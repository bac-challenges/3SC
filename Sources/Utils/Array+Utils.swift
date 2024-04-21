//
//  Array+Utils.swift
//  Pokemon
//
//  Created by emile on 20/04/2024.
//

import Foundation

extension Array {
    public init(count: Int, createElement: (Int) -> Element) {
        self = (0 ..< count).map { index in createElement(index) }
    }
}

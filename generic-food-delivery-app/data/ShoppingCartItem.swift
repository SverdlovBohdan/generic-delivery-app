//
//  ShoppingCartItem.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 16.11.2023.
//

import Foundation

struct ShoppingCartItem: Codable, Identifiable, Hashable {
    var id: UUID
    var product: ProductItem
    var isPresented: Bool = true
}

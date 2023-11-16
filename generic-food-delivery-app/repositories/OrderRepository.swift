//
//  OrderRepository.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 15.11.2023.
//

import Foundation

protocol OrderRepository {
    func read() -> [ShoppingCartItem]
    func write(order: [ShoppingCartItem])
}

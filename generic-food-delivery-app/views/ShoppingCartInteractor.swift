//
//  CartInteractor.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 15.11.2023.
//

import Foundation

protocol ShoppingCartInteractor {
    typealias SideEffect = ([ShoppingCartItem]) -> Void
    
    func addToCart(product: ProductItem, sideEffect: SideEffect) -> Void
    func removeFromCart(item: ShoppingCartItem, sideEffect: SideEffect) -> Void
    func getOrder(sideEffect: SideEffect) -> Void
}

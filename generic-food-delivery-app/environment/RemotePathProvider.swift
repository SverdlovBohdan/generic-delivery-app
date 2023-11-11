//
//  RequestPathProvider.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

protocol RemotePathProvider {
    func getCategoriesPath() -> String
    func getCategoryProducts(for category: Category) -> String
}

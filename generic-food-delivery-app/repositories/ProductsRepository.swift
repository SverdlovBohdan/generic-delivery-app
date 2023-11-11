//
//  ProductsRepository.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

protocol ProductsRepository {
    func getProducts(for category: Category) async -> Result<[ProductItem], RepositoryError>
    func getProducts(for categories: [Category]) async -> [Result<[ProductItem], RepositoryError>]
}

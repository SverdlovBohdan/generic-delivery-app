//
//  RestarauntRepository.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Alamofire
import Foundation

class RestarauntRepository: CategoriesRepository, ProductsRepository {
    // TODO: Use DI
    private var remotePaths: RemotePathProvider = RemotePaths()

    func getCategories() async -> Result<[Category], RepositoryError> {
        await AF.request(remotePaths.getCategoriesPath(), interceptor: .retryPolicy)
            .serializingDecodable([Category].self)
            .result
    }

    func getProducts(for category: Category) async -> Result<[ProductItem], RepositoryError> {
        await AF.request(remotePaths.getCategoryProducts(for: category), interceptor: .retryPolicy)
            .serializingDecodable([ProductItem].self)
            .result
    }

    func getProducts(for categories: [Category]) async -> [Result<[ProductItem], RepositoryError>] {
        await withTaskGroup(of: Result<[ProductItem], RepositoryError>.self) { group in
            for category in categories {
                group.addTask {
                    await self.getProducts(for: category)
                }
            }

            var allProducts: [Result<[ProductItem], RepositoryError>] = []
            for await categoryProducts in group {
                allProducts.append(categoryProducts)
            }

            return allProducts
        }
    }
}

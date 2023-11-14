//
//  RemotePaths.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

class RemotePaths: RemotePathProvider {
    // TODO: Use DI
    private var configuration: ApplicationConfiguration = DebugConfiguration()
    private var paths: ResourcesPath = VilkiPalkiPaths()

    func getCategoriesPath() -> String {
        "\(configuration.baseUrl)/\(paths.categories)"
    }

    func getCategoryProducts(for category: Category) -> String {
        "\(configuration.baseUrl)/\(paths.products)&category=\(category.id)"
    }
}

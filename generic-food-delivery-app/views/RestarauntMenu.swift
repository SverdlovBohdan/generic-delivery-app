//
//  RestarauntMenu.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import SwiftUI

struct RestarauntMenu: View {
    //TODO: Use DI
    private var categoriesRepository: CategoriesRepository = RestarauntRepository()
    private var productsRepository: ProductsRepository = RestarauntRepository()
    
    @State private var categories: [Category] = []
    @State private var error: String = ""
    @State private var products: [ProductItem] = []
    
    var body: some View {
        List {
            Text(error)
            
            ForEach(categories, id: \.id) { item in
                Text("\(item.id) \(item.name) \(item.slug)")
            }
            
            ForEach(products, id: \.id) { product in
                Text("\(product.remoteId) \(product.name) \(product.price)")
            }
        }
        .task {
            let result = await categoriesRepository.getCategories()
            
            switch result {
            case .success(let downloadedCategories):
                categories = downloadedCategories

                let allProducts = await productsRepository.getProducts(for: categories)
                allProducts.forEach({ productResult in
                    switch productResult {
                    case .success(let categoryProducts):
                        products.append(contentsOf: categoryProducts)

                    case .failure(_):
                        break
                    }
                })
                
            case .failure(let repositoryError):
                error = repositoryError.localizedDescription
            }
        }
    }
}

#Preview {
    RestarauntMenu()
}

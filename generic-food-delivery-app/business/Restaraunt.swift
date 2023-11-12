//
//  RestarauntInteractor.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

class Restaraunt: ProductsProvider, CategoryIdToEmojiMapper {
    //TODO: Use DI
    private var categoriesRepository: CategoriesRepository = RestarauntRepository()
    private var productsRepository: ProductsRepository = RestarauntRepository()
    
    func getAvailableProducts(sideEffect: ProductsProvider.SideEffect) async {
        let result = await categoriesRepository.getCategories()
        
        switch result {
        case .success(let categories):
            let allProducts = await productsRepository.getProducts(for: categories)
            var availableProducts: [ProductItem] = []
            allProducts.forEach { categoryProductsResult in
                if case .success(let products) = categoryProductsResult {
                    var productsWithParentCategory = products.map { productItem in
                        var item: ProductItem = productItem
                        
                        categories.forEach { categoryItem in
                            if categoryItem.children.contains(where: { subcategory in
                                return item.category.id == subcategory.id
                            }) {
                                item.category.id = categoryItem.id
                            }
                        }
                        
                        return item
                    }
                    
                    availableProducts.append(contentsOf: productsWithParentCategory.filter(\.visible))
                }
            }
            sideEffect(.success(availableProducts))
   
        case .failure(let categoriesCannotBeObtained):
            sideEffect(.failure(categoriesCannotBeObtained))
        }
    }
    
    func map(id: Int) -> String {
        switch id {
        case 14:
            return "🥘"
        case 21:
            return "🥘"
        case 23:
            return "🥘"
        case 26:
            return "🥘"
        case 2:
            return "🥘"
        case 8:
            return "🥘"
        case 10:
            return "🥘"
        case 13:
            return "🥘"
        case 11:
            return "🥘"
        case 4:
            return "🥘"
        case 7:
            return "🥘"
        case 12:
            return "🥘"
        case 3:
            return "🥘"
        default:
            return "🥘"
        }
    }
}

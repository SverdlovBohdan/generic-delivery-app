//
//  RestarauntMenu.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import SwiftUI

struct RestarauntMenuView: View {
    //TODO: Use DI
    private var restaraunt: ProductsProvider = Restaraunt()
    private var categoryIdToEmojii: CategoryIdToEmojiMapper = Restaraunt()
    
    @State private var error: String = ""
    @State private var products: [ProductItem] = []
    @State private var screenWidth: CGFloat = .zero
    
    private let rows = Array<GridItem>(repeating: GridItem(.flexible()), count: 3)
    
    private var groupedProductsByCategories: [Int: [ProductItem]] {
        Dictionary(grouping: products, by: \.category.id)
    }
    
    private var categoriesIds: [Int] {
        Array<Int>(groupedProductsByCategories.keys).sorted()
    }
    
    @ViewBuilder
    private func makeSectionTitle(categoryId: Int) -> some View {
        HStack {
            Text(categoryIdToEmojii.map(id: categoryId))
            Spacer()
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    
                    ForEach(categoriesIds, id: \.self) { categoryId in
                        Section(header: makeSectionTitle(categoryId: categoryId)) {
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: rows) {
                                    ForEach(groupedProductsByCategories[categoryId]!, id: \.id) { product in
                                        ProductRowItemView(product: product)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "Menu"))
            .task {
                await restaraunt.getAvailableProducts { productsResult in
                    switch productsResult {
                    case .success(let availableProduts):
                        products = availableProduts
                    case .failure(let productsError):
                        error = productsError.localizedDescription
                    }
                }
            }
        }
    }
}

#Preview {
    RestarauntMenuView()
}

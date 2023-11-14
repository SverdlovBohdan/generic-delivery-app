//
//  RestarauntMenuView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import SwiftUI

struct RestarauntMenuView: View {
    // TODO: Use DI
    private var restaraunt: ProductsProvider = Restaraunt.shared
    private var categoryData: CategoryDataGetter = Restaraunt.shared

    
    @Environment(NavigationStore.self) private var navigation: NavigationStore
    @State private var viewState: RestarauntViewStateStore = .makeDefault()
    
    private let rows = [GridItem](repeating: GridItem(.flexible()), count: 3)
    
    private var groupedProductsByCategories: [Int: [ProductItem]] {
        Dictionary(grouping: viewState.products, by: \.category.id)
    }
    
    private var categoriesIds: [Int] {
        [Int](groupedProductsByCategories.keys).sorted()
    }
    
    private let progressTitle: String = .init("🤤 ") + String(localized: "Looking a menu")
    private let errorTitle: String = .init("😐 ") + String(localized: "Crap! We have an error")
    
    var body: some View {
        NavigationStack(path: navigationPathBinding) {
            ScrollView(showsIndicators: false) {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(categoriesIds, id: \.self) { categoryId in
                        Section(header: CategorySectionHeaderView(categoryId: categoryId)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: rows) {
                                    ForEach(groupedProductsByCategories[categoryId]!, id: \.id) { product in
                                        ProductRowItemView(product: product)
                                            .padding(.leading, 8)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                        }
                    }
                }
            }
            .navigationDestination(for: ProductItem.self, destination: { product in
                ProductView(product: product)
            })
            .navigationTitle(String(localized: "Menu"))
            .overlay(content: {
                if viewState.inProgress {
                    ProgressView(progressTitle)
                        .ignoresSafeArea()
                } else if let error = viewState.error {
                    HStack {
                        Text(errorTitle)
                            .font(.subheadline)
                        Text(error)
                        
                        Button(String(localized: "Try againt")) {
                            viewState.dispatch(action: .showProgress)
                            Task { @MainActor in
                                await getProducts()
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
            })
            .task {
                if viewState.viewState.noProducts {
                    viewState.dispatch(action: .showProgress)
                    await getProducts()
                }
        }
        }
    }
    
    private var navigationPathBinding: Binding<NavigationPath> {
        .init {
            navigation.path
        } set: { newValue in
            navigation.path = newValue
        }

    }
    
    private func getProducts() async {
        await restaraunt.getAvailableProducts { productsResult in
            switch productsResult {
            case let .success(availableProduts):
                viewState.dispatch(action: .setProducts(availableProduts))
            case let .failure(productsError):
                viewState.dispatch(action: .setError(productsError.localizedDescription))
            }
        }
    }
}

#Preview {
    RestarauntMenuView()
        .environment(NavigationStore.makeDefault())
}

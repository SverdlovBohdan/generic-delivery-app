//
//  ProductView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 13.11.2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct ProductView: View {
    @Environment(NavigationStore.self) private var navigation: NavigationStore

    var product: ProductItem

    // TODO: Use DI
    private var categoryData: CategoryDataGetter = Restaraunt.shared
    private var shoppingCart: ShoppingCartInteractor = Restaraunt.shared

    @State private var categoryName: String = ""

    private let imageWidth: CGFloat = 120

    init(product: ProductItem) {
        self.product = product
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                WebImage(url: .init(string: product.backgroundImage.url))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                    .task {
                        categoryName = await categoryData.getCategoryName(id: product.category.id)
                    }

                VStack {
                    WebImage(url: .init(string: product.mainImage.url))
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .offset(y: -imageWidth / 2.0)
                        .frame(width: imageWidth, height: imageWidth)

                    Group {
                        Text(product.name)
                            .font(.title)
                        Text(categoryName)
                            .font(.subheadline)
                    }
                    .foregroundStyle(.white)

                    Button(action: {
                        shoppingCart.addToCart(product: product) { _ in
                        }
                    }, label: {
                        HStack {
                            Text(String(format: "%.2f", product.price))
                                .font(.title2)
                            Image(systemName: "basket")
                        }
                        .frame(width: imageWidth * 1.5)
                    })
                    .buttonStyle(
                        GrowingButton(clipShape: RoundedRectangle(cornerRadius: imageWidth / 10.0),
                                      topBottomPadding: 12.0,
                                      foregroundColor: .blue,
                                      backgroundColor: .white)
                    )

                    Image(systemName: "chevron.compact.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageWidth * 0.25)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding()
                }

                Text(product.description)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
            }
            .navigationBarBackButtonHidden()
            .background {
                WebImage(url: .init(string: product.backgroundImage.url))
                    .placeholder(content: {
                        Color("DefaultColor")
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 56)
            }
            .ignoresSafeArea(.container, edges: .top)
            .overlay(alignment: .topLeading) {
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth * 0.2)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding()
                    .onTapGesture {
                        navigation.dispatch(action: .openRootView)
                    }
            }
        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            ProductView(product: .preview)
                .environment(NavigationStore.makeDefault())
        }
    }
}

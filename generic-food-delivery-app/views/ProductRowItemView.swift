//
//  ProductRowItemView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct ProductRowItemView: View {
    var product: ProductItem
    private var presentingInOrder: Bool
    
    // TODO: Use DI
    private var shoppingCart: ShoppingCartInteractor = Restaraunt.shared

    @Environment(NavigationStore.self) private var navigation: NavigationStore
    
    private var imageWidth: CGFloat = 60.0

    init(product: ProductItem) {
        self.product = product
        self.presentingInOrder = false
    }
    
    init(shoppingCartItem: ShoppingCartItem) {
        self.product = shoppingCartItem.product
        self.presentingInOrder = true
    }

    var body: some View {
        HStack {
            Group {
                WebImage(url: .init(string: product.mainImage.url))
                    .resizable()
                    .indicator(.activity)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: imageWidth, height: imageWidth)

                VStack(alignment: .leading) {
                    Text(product.name)
                        .lineLimit(2)
                    Text(product.description)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
                .frame(width: imageWidth * 3)
            }
            .onTapGesture {
                if !presentingInOrder {
                    navigation.dispatch(action: .openProductView(product))
                }
            }

            Spacer()

            if !presentingInOrder {
                Button(action: {
                    shoppingCart.addToCart(product: product) { _ in
                    }
                }, label: {
                    HStack {
                        Text(String(format: "%.2f", product.price))
                        Image(systemName: "basket")
                    }
                })
                .buttonStyle(GrowingButton(clipShape: Capsule()))
            } else {
                Text(String(format: "%.2f", product.price))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductRowItemView(product: .preview)
            .environment(NavigationStore.makeDefault())
    }
}

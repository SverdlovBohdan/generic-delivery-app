//
//  ProductRowItemView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductRowItemView: View {
    var product: ProductItem

    private var imageWidth: CGFloat = 60.0

    init(product: ProductItem) {
        self.product = product
    }

    var body: some View {
        HStack {
            WebImage(url: .init(string: product.mainImage.url))
                .resizable()
                .indicator(.activity)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width: imageWidth, height: imageWidth)

            NavigationLink(destination: ProductView(product: product)) {
                VStack(alignment: .leading) {
                    Text(product.name)
                        .lineLimit(2)
                    Text(product.description)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
                .frame(width: imageWidth * 3)
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()

            Button(action: {}, label: {
                HStack {
                    Text(String(format: "%.2f", product.price))
                    Image(systemName: "basket")
                }
            })
            .buttonStyle(GrowingButton(clipShape: Capsule()))
        }
    }
}

#Preview {
    NavigationStack {
        ProductRowItemView(product: .preview)
    }
}

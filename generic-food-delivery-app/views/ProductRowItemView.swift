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
    
    @Environment(NavigationStore.self) private var navigation: NavigationStore
    
    private var imageWidth: CGFloat = 60.0
    
    init(product: ProductItem) {
        self.product = product
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
                navigation.dispatch(action: .openProductView(product))
            }
            
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
            .environment(NavigationStore.makeDefault())
    }
}

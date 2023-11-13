//
//  ProductRowItemView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import SwiftUI

let url: String = "https://vilki-palki.od.ua/storage/img/2c/b6/1696228577боулзкуркою.jpg"

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 4)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ProductRowItemView: View {
    var product: ProductItem
    
    private var imageWidth: CGFloat = 60.0
    
    init(product: ProductItem) {
        self.product = product
    }
    
    var body: some View {        
        HStack {
            AsyncImage(url: .init(string: url)) { image in
                image.resizable().clipShape(RoundedRectangle(cornerRadius: 15))
            } placeholder: {
                ProgressView()
            }
            .frame(width: imageWidth, height: imageWidth)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .lineLimit(2)
                Text(product.description)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
            }
            .frame(width: imageWidth * 3)
            
            Spacer()
            
            Button(action: {}, label: {
                HStack {
                    Text(String(format: "%.2f", product.price))
                    Image(systemName: "basket")
                }
            })
            .buttonStyle(GrowingButton())
        }
    }
}

#Preview {
    ProductRowItemView(product: .preview)
}

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

    @State private var imageAnimationTrigger: Bool = false
    private var imageWidth: CGFloat = 60.0

    enum ImageAnimationPhases: CaseIterable {
        case origin
        case left
        case right

        func randomDuration(interval: TimeInterval, withVariance variance: Double) -> TimeInterval {
            let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
            return interval + variance * random
        }

        static var phases: [ImageAnimationPhases] {
            [ImageAnimationPhases.origin] + [ImageAnimationPhases.left, ImageAnimationPhases.right].shuffled()
        }

        var offset: Double {
            switch self {
            case .left:
                -2.0
            case .right:
                4.0
            case .origin:
                0.0
            }
        }

        var angle: Double {
            switch self {
            case .left:
                -2.0
            case .right:
                2.0
            case .origin:
                0.0
            }
        }
    }

    init(product: ProductItem) {
        self.product = product
        presentingInOrder = false
    }

    init(shoppingCartItem: ShoppingCartItem) {
        product = shoppingCartItem.product
        presentingInOrder = true
    }

    var body: some View {
        HStack {
            Group {
                WebImage(url: .init(string: product.mainImage.url))
                    .onSuccess(perform: { _, _, _ in
                        imageAnimationTrigger.toggle()
                    })
                    .resizable()
                    .indicator(.activity)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: imageWidth, height: imageWidth)
                    .phaseAnimator(ImageAnimationPhases.phases,
                                   trigger: imageAnimationTrigger)
                { content, phase in
                    content.offset(x: phase.offset)
                        .rotationEffect(Angle.degrees(phase.angle))
                } animation: { phase in
                    .easeInOut(
                        duration: phase.randomDuration(
                            interval: 0.18,
                            withVariance: 0.025
                        )
                    )
                }

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

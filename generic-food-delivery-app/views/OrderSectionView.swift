//
//  OrderSectionView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import SwiftUI

struct OrderSectionView: View {
    // TODO: Use DI
    private var shoppingCart: ShoppingCartInteractor = Restaraunt.shared
    
    @Bindable private var viewState: OrderViewStateStore
    
    init(viewState: Bindable<OrderViewStateStore>) {
        _viewState = viewState
    }
    
    var body: some View {
        Section {
            ForEach(viewState.viewState.items.indices, id: \.self) { idx in
                ProductRowItemView(shoppingCartItem: viewState.viewState.items[idx])
            }
            .onDelete(perform: { indexSet in
                shoppingCart.removeFromCart(shoppingCartItem: viewState.viewState.items[indexSet.first!]) { newOrder in
                    // WORKAROUND: speedup animation to hide item removing animation glitch
                    withAnimation(.bouncy(duration: 0.01)) {
                        viewState.dispatch(action: .setOrder(newOrder))
                    }
                }
            })
        } header: {
            HStack {
                Text(String(localized: "🍱 Order"))
                Spacer()
                Label(String(localized: "swipe to remove"), systemImage: "hand.point.up.left.and.text")
            }
        }
        .onAppear(perform: {
            shoppingCart.getOrder { shoppingCartItems in
                viewState.dispatch(action: .setOrder(shoppingCartItems))
            }
        })
    }
}

#Preview {
    Form {
        OrderSectionView(viewState: .init(.makeDefault()))
    }
}

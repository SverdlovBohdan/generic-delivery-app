//
//  OrderView.swift
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
        self._viewState = viewState
    }

    var body: some View {
        Section {
            ForEach(viewState.items.indices, id: \.self) { idx in
                ProductRowItemView(shoppingCartItem: viewState.items[idx])
            }
            .onDelete(perform: { indexSet in
                // FIXME: List animation glitches
                shoppingCart.removeFromCart(shoppingCartItem: viewState.items[indexSet.first!]) { _ in
                    viewState.dispatch(action: .removeItem(indexSet.first!))
                }
            })
        } header: {
            HStack {
                Text(String(localized: "🍱 Order"))
                Spacer()
                Label(String(localized: "remove"), systemImage: "hand.point.up.left.and.text")
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

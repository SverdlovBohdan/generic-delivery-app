//
//  OrderView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import SwiftUI

struct OrderView: View {
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
            Text(String(localized: "🍱 Order"))
        }
        .onAppear(perform: {
            shoppingCart.getOrder { shoppingCartItems in
                viewState.dispatch(action: .setOrder(shoppingCartItems))
            }
        })
        
        Section {
            Button(action: {
                print("### Make order button")
            }, label: {
                HStack {
                    Text(String(localized: "Make order"))
                    Spacer()
                    Text(String(format: "%.2f", viewState.viewState.total) + String("₴"))
                        .font(.title3)
                }
            })
            .disabled(!viewState.viewState.isValid)
        }
    }
}

#Preview {
    NavigationStack {
        Form {
            OrderView(viewState: .init(.makeDefault()))
        }
    }
}

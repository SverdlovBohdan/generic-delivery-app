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
    
    @State private var viewState: OrderStore = .makeDefault()
    
    var body: some View {
        Section {
            ForEach(viewState.items.indices, id: \.self) { idx in
                ProductRowItemView(shoppingCartItem: viewState.items[idx])
            }
            
            Button(String(localized: "Make order")) {
            }
        } header: {
            Text(String(localized: "Order"))
        }
        .onAppear(perform: {
            shoppingCart.getOrder { shoppingCartItems in
                viewState.dispatch(action: .setOrder(shoppingCartItems))
            }
        })
    }
}

#Preview {
    NavigationStack {
        List {
            OrderView()
        }
    }
}

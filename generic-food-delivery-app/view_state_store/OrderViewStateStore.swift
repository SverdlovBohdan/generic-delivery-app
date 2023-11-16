//
//  OrderViewStateStore.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import Foundation

enum OrderAction: CustomStringConvertible {
    case removeProduct(IndexSet)
    case setOrder([ShoppingCartItem])

    var description: String {
        switch self {
        case .removeProduct:
            return "removeProduct"
//        case .resetOrder:
//            return "resetOrder"
//        case .setValidationStatus:
//            return "setValidationStatus"
//        case .showSendingView:
//            return "showSendingView"
//        case .setError(_):
//            return "setError"
        case .setOrder:
            return "setOrder"
        }
    }
}

struct OrderState {
    var items: [ShoppingCartItem] = []
    var isValid: Bool = false
    var isSendingToRestaraunt: Bool = false
    var error: String?
}

typealias OrderStore = ViewStateStore<OrderAction,
    OrderState>

func orderReducer(currentState: inout OrderState,
                  action: OrderAction)
{
    switch action {
    case let .removeProduct(indexSet):
        currentState.items.remove(atOffsets: indexSet)
        currentState.isValid = !currentState.items.isEmpty
    case let .setOrder(cartItems):
        currentState.items = cartItems
        currentState.isValid = !currentState.items.isEmpty
    }
}

extension ViewStateStore where State == OrderState, Action == OrderAction {
    static func makeDefault() -> OrderStore {
        OrderStore(initialState: .init(), reducer: orderReducer)
    }
}

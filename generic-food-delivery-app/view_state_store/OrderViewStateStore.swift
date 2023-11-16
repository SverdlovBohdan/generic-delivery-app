//
//  OrderViewStateStore.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import Foundation

enum OrderAction: CustomStringConvertible {
    case setOrder([ShoppingCartItem])
    case removeItem(Int)

    var description: String {
        switch self {
        case .removeItem(_):
            return "removeItem"
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
    var isSendingToRestaraunt: Bool = false
    var error: String?
    
    var total: Float {
        items.reduce(.zero, { totalCost, item in
            return totalCost + item.product.price
        })
    }
    
    var isValid: Bool {
        return !items.isEmpty
    }
}

typealias OrderViewStateStore = ViewStateStore<OrderAction,
    OrderState>

func orderReducer(currentState: inout OrderState,
                  action: OrderAction)
{
    switch action {
    case let .setOrder(cartItems):
        currentState.items = cartItems
    case let .removeItem(index):
        currentState.items.remove(at: index)
    }
}

extension ViewStateStore where State == OrderState, Action == OrderAction {
    static func makeDefault() -> OrderViewStateStore {
        OrderViewStateStore(initialState: .init(), reducer: orderReducer)
    }
}

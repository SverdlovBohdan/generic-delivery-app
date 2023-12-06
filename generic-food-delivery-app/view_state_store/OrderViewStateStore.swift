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
    case reset
    case setAccoutFullfilledFlag(Bool)

    var description: String {
        switch self {
        case .removeItem:
            "removeItem"
        case .reset:
            "reset"
        case .setOrder:
            "setOrder"
        case let .setAccoutFullfilledFlag(isFulfilled):
            "setAccoutFullfilledFlag \(isFulfilled)"
        }
    }
}

struct OrderState {
    var items: [ShoppingCartItem] = []
    var isSendingToRestaraunt: Bool = false
    var error: String?

    var total: Float {
        items.reduce(.zero) { totalCost, item in
            if item.isPresented {
                return totalCost + item.product.price
            }
            
            return totalCost
        }
    }
    
    var isAccountInfoFullfilled: Bool = false

    var isValid: Bool {
        !items.isEmpty
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
    case .reset:
        currentState = .init()
        
    case let .setAccoutFullfilledFlag(isValid):
        currentState.isAccountInfoFullfilled = isValid
    }
}

extension ViewStateStore where State == OrderState, Action == OrderAction {
    static func makeDefault() -> OrderViewStateStore {
        OrderViewStateStore(initialState: .init(), reducer: orderReducer)
    }
}

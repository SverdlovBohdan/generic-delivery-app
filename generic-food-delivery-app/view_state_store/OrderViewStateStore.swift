//
//  OrderViewStateStore.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import Foundation

enum OrderAction: CustomStringConvertible {
    case addProduct(ProductItem)
    case removeProduct(IndexSet)
    case resetOrder
    case setValidationStatus(Bool)
    case showSendingView
    case setError(String)
    case setCachedOrder([ProductItem])

    var description: String {
        switch self {
        case .addProduct(_):
            return "addProduct"
        case .removeProduct:
            return "removeProduct"
        case .resetOrder:
            return "resetOrder"
        case .setValidationStatus:
            return "setValidationStatus"
        case .showSendingView:
            return "showSendingView"
        case .setError(_):
            return "setError"
        case .setCachedOrder(_):
            return "setCachedOrder"
        }
    }
}

struct OrderState {
    var products: [ProductItem] = []
    var isValid: Bool = false
    var presentingSendingView: Bool = false
    var error: String? = nil
}

typealias OrderStore = ViewStateStore<OrderAction,
                                           OrderState>

func navigationReducer(currentState: inout OrderState,
                       action: OrderAction)
{
    switch action {
    case .addProduct(let product):
        currentState.products.append(product)
        currentState.isValid = true
        
    case .resetOrder:
        currentState = OrderState()
        
    case .removeProduct(let indexSet):
        currentState.products.remove(atOffsets: indexSet)
        currentState.isValid = !currentState.products.isEmpty
        
    case .setError(let error):
        currentState.error = error
        
    case .setValidationStatus(let validationStatus):
        currentState.isValid = validationStatus
        
    case .showSendingView:
        currentState.presentingSendingView = true
        
    default:
        break
    }
}


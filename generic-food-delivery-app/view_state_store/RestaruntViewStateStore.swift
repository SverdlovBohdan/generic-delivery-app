//
//  RestaruntViewStateStore.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 13.11.2023.
//

import Foundation

enum RestarauntAction: CustomStringConvertible {
    case setProducts([ProductItem])
    case setError(String)
    case showProgress
    
    var description: String {
        switch self {
        case .setError(let error):
            return "setError \(error.description)"
        case .setProducts(let products):
            return "setProducts \(products.count)"
        case .showProgress:
            return "showProgress"
        }
    }
}

struct RestarauntState {
    var products: [ProductItem] = []
    var error: String? = nil
    var inProgress: Bool = true
    
    var noProducts: Bool {
        return products.isEmpty
    }
}

typealias RestarauntViewStateStore = ViewStateStore<RestarauntAction, RestarauntState>

func retarauntReducer(state: inout RestarauntState, action: RestarauntAction) -> Void {
    switch action {
    case .setError(let error):
        state.error = error
        state.inProgress = false
        state.products = []
    case .setProducts(let products):
        state.products = products
        state.error = nil
        state.inProgress = false
    case .showProgress:
        state.inProgress = true
        state.error = nil
        state.products = []
    }
}

extension ViewStateStore where Action == RestarauntAction, State == RestarauntState {
    static func makeDefault() -> RestarauntViewStateStore {
        return RestarauntViewStateStore(initialState: RestarauntState(), reducer: retarauntReducer)
    }
}
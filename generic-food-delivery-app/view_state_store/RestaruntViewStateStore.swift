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
        case let .setError(error):
            "setError \(error.description)"
        case let .setProducts(products):
            "setProducts \(products.count)"
        case .showProgress:
            "showProgress"
        }
    }
}

struct RestarauntState {
    var products: [ProductItem] = []
    var error: String?
    var inProgress: Bool = true

    var noProducts: Bool {
        products.isEmpty
    }
}

typealias RestarauntViewStateStore = ViewStateStore<RestarauntAction, RestarauntState>

func retarauntReducer(state: inout RestarauntState, action: RestarauntAction) {
    switch action {
    case let .setError(error):
        state.error = error
        state.inProgress = false
        state.products = []
    case let .setProducts(products):
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
        RestarauntViewStateStore(initialState: RestarauntState(), reducer: retarauntReducer)
    }
}

//
//  NavigationViewStateStore.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import Foundation
import SwiftUI

enum NavigationAction: CustomStringConvertible {
    case openProductView(ProductItem)
    case openRootView
    
    var description: String {
        switch self {
        case .openProductView(_):
            return "openProductView"
        case .openRootView:
            return "openRootView"
        }
    }
}

struct NavigationState {
    var path: NavigationPath = .init()
}

typealias NavigationStore = ViewStateStore<NavigationAction,
                                           NavigationState>

func navigationReducer(currentState: inout NavigationState,
                       action: NavigationAction) {
    switch action {
    case .openProductView(let product):
        if currentState.path.isEmpty {
            currentState.path = NavigationPath([product])
        }
        
    case .openRootView:
        currentState.path = NavigationPath()
    }
}

extension ViewStateStore where State == NavigationState, Action == NavigationAction {
    static var shared: NavigationStore {
        return NavigationStore(initialState: .init(), reducer: navigationReducer)
    }
    
    static func makeDefault() -> NavigationStore {
        return NavigationStore(initialState: .init(), reducer: navigationReducer)
    }
}

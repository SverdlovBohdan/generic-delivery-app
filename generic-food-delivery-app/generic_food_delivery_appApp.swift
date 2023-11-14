//
//  generic_food_delivery_appApp.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import SwiftUI

@main
struct generic_food_delivery_appApp: App {
    @State private var navigationViewState: NavigationStore = .makeDefault()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(navigationViewState)
        }
    }
}

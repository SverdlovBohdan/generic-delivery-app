//
//  ContentView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RestarauntMenuView()
                .tabItem {
                    Label("Menu", systemImage: "rectangle")
                }

            Text("1")
                .tabItem {
                    Label("My order", systemImage: "rectangle")
                }

            AccountView()
                .tabItem {
                    Label("Account", systemImage: "rectangle")
                }
        }
    }
}

#Preview {
    ContentView()
}

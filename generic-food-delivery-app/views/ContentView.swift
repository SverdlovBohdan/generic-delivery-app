//
//  ContentView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(NavigationStore.self) private var navigation: NavigationStore

    private var navigationPathBinding: Binding<NavigationPath> {
        .init {
            navigation.path
        } set: { newValue in
            navigation.path = newValue
        }
    }

    var body: some View {
        NavigationStack(path: navigationPathBinding) {
            TabView {
                RestarauntMenuView()
                    .tabItem {
                        Label("Menu", systemImage: "heart.text.square")
                    }

                OrderInfoView()
                    .tabItem {
                        Label("My order", systemImage: "basket")
                    }

                Form {
                    AccountInfoView(updatable: true)
                }
                .tabItem {
                    Label("Account", systemImage: "person")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(NavigationStore.makeDefault())
}

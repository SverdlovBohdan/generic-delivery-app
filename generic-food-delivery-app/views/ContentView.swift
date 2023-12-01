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

                UserDataView { accountViewState in
                    AccountSectionView(viewState: accountViewState, editable: false)
                } orderSection: { orderViewState in
                    OrderSectionView(viewState: orderViewState)
                }
                .tabItem {
                    Label("My order", systemImage: "basket")
                }

                UserDataView { accountViewState in
                    AccountSectionView(viewState: accountViewState, editable: true)
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

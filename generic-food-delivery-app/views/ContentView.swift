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
            
            NavigationStack {
                UserDataView { accountViewState in
                    AccountView(viewState: accountViewState, editable: false)
                } orderSection: {
                    OrderView()
                }
            }
            .tabItem {
                Label("My order", systemImage: "rectangle")
            }
            
            NavigationStack {
                UserDataView { accountViewState in
                    AccountView(viewState: accountViewState, editable: true)
                }
            }
            .tabItem {
                Label("Account", systemImage: "rectangle")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(NavigationStore.makeDefault())
}

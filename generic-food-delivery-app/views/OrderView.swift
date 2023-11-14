//
//  OrderView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import SwiftUI

struct OrderView: View {
    var body: some View {
        Section {
            Text("something")
        } header: {
            Text(String(localized: "Order"))
        }
    }
}

#Preview {
    NavigationStack {
        OrderView()
    }
}

//
//  GenericUserDataView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import SwiftUI

struct OrderInfoView: View {
    @State private var orderViewState: OrderViewStateStore = .makeDefault()
    
    // TODO: Use DI
    private var accountRepository: AccountRepository = AccountUserDefaults()
    
    var body: some View {
        Form {
            AccountInfoView(editable: false)
                .onPreferenceChange(AccountInfoValidationPreferenceKey.self, perform: { value in
                    orderViewState.dispatch(action: .setAccoutFullfilledFlag(value))
                })
            
            @Bindable var orderState = orderViewState
            OrderSectionView(viewState: $orderState)
            
            Button(action: {
                print("### Make order button")
            }, label: {
                HStack {
                    Text(String(localized: "Make order"))
                    Spacer()
                    Text(String(format: "%.2f", orderViewState.viewState.total) + String("₴"))
                        .font(.title2)
                }
                .contentTransition(.numericText())
            })
            .disabled(!orderViewState.viewState.isValid || !orderViewState.isAccountInfoFullfilled)            
        }
    }
}

#Preview {
    OrderInfoView()
}

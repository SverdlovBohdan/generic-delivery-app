//
//  OrderInfoView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import SwiftUI

struct CustomerDataForOrderPreferenceKey: PreferenceKey {
    struct CustomerData: Equatable {
        var customer: Customer
        var isValid: Bool
    }

    static var defaultValue: CustomerData = .init(customer: .unknownUser, isValid: false)

    static func reduce(value: inout CustomerData, nextValue: () -> CustomerData) {
        value = nextValue()
    }
}

struct OrderInfoView: View {
    @State private var viewState: OrderViewStateStore = .makeDefault()

    // TODO: Use DI
    private let accountRepository: AccountRepository = AccountUserDefaults()

    var body: some View {
        Form {
            AccountInfoView(updatable: false)
                .onPreferenceChange(CustomerDataForOrderPreferenceKey.self, perform: { value in
                    viewState.dispatch(action: .setCustomerData(value))
                })

            @Bindable var orderState = viewState
            OrderSectionView(viewState: $orderState)

            Button(action: {
                print("### Make order button")
            }, label: {
                HStack {
                    Text(String(localized: "Make order"))
                    Spacer()
                    Text(String(format: "%.2f", viewState.viewState.total) + String("₴"))
                        .font(.title2)
                }
                .contentTransition(.numericText())
            })
            .disabled(!viewState.viewState.isValid || !isAccountFulfilled)
        }
    }

    private var isAddressKnown: Bool {
        !viewState.customer.addresses.isEmpty
    }

    private var isUserInfoFulfilled: Bool {
        !viewState.customer.name.isEmpty && !viewState.customer.phone.isEmpty
    }

    private var isAccountFulfilled: Bool {
        viewState.isCustomerDataValid && isAddressKnown && isUserInfoFulfilled
    }
}

#Preview {
    OrderInfoView()
}

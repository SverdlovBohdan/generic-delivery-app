//
//  GenericUserDataView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import SwiftUI

struct GenericUserDataView<AccountViewType: View, OrderViewType: View>: View {
    @State private var accountViewState: AccountViewStateStore = .makeDefault()
    @State private var orderViewState: OrderViewStateStore = .makeDefault()

    // TODO: Use DI
    private var accountRepository: AccountRepository = AccountUserDefaults()

    private var accountSection: ((Bindable<AccountViewStateStore>) -> AccountViewType)?
    private var orderSection: ((Bindable<OrderViewStateStore>) -> OrderViewType)?

    // TODO: Use @ViewBuilder?
    init(accountSection: ((Bindable<AccountViewStateStore>) -> AccountViewType)? = nil,
         orderSection: ((Bindable<OrderViewStateStore>) -> OrderViewType)? = nil)
    {
        self.accountSection = accountSection
        self.orderSection = orderSection
    }

    var body: some View {
        Form {
            if let accountSection {
                @Bindable var accountState = accountViewState
                accountSection($accountState)
                    .animation(.easeIn, value: accountViewState.error)

                Button(String(localized: "Update")) {
                    accountRepository.write(account: Customer(name: accountViewState.name,
                                                              phone: accountViewState.phone,
                                                              paymentMethod: accountViewState.paymentMethod,
                                                              addresses: accountViewState.addresses))
                    accountViewState.dispatch(action: .setValidationStatus(false))
                }
                .disabled(!canUpdateAccount)
            }

            if let orderSection {
                @Bindable var orderState = orderViewState
                orderSection($orderState)
                
                Section {
                    Button(action: {
                        print("### Make order button")
                    }, label: {
                        HStack {
                            Text(String(localized: "Make order"))
                            Spacer()
                            Text(String(format: "%.2f", orderViewState.viewState.total) + String("₴"))
                                .font(.title3)
                        }
                    })
                    .disabled(!orderViewState.viewState.isValid)
                }
            }
        }
    }

    private var canUpdateAccount: Bool {
        accountViewState.isValid ?? false
    }
}

typealias UserDataView = GenericUserDataView<AccountSectionView, OrderSectionView>

#Preview {
    UserDataView()
}

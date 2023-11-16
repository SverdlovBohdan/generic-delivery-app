//
//  GenericUserDataView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 14.11.2023.
//

import SwiftUI

struct GenericUserDataView<AccountViewType: View, OrderViewType: View>: View {
    @State private var viewState: AccountViewStateStore = .makeDefault()

    // TODO: Use DI
    private var accountRepository: AccountRepository = AccountUserDefaults()

    private var accountSection: ((Bindable<AccountViewStateStore>) -> AccountViewType)?
    private var orderSection: (() -> OrderViewType)?

    // TODO: Use @ViewBuilder?
    init(accountSection: ((Bindable<AccountViewStateStore>) -> AccountViewType)? = nil,
         orderSection: (() -> OrderViewType)? = nil)
    {
        self.accountSection = accountSection
        self.orderSection = orderSection
    }

    var body: some View {
        List {
            @Bindable var accountState = viewState
            if let accountSection {
                accountSection($accountState)
            }

            if let orderSection {
                orderSection()
            }
        }
        .animation(.easeIn, value: viewState.error)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Update")) {
                    accountRepository.write(account: Customer(name: viewState.name,
                                                              phone: viewState.phone,
                                                              paymentMethod: viewState.paymentMethod,
                                                              addresses: viewState.addresses))
                    viewState.dispatch(action: .setValidationStatus(false))
                }
                .disabled(!canUpdateAccount)
            }
        }
    }

    private var canUpdateAccount: Bool {
        viewState.isValid ?? false
    }
}

typealias UserDataView = GenericUserDataView<AccountView, OrderView>

#Preview {
    UserDataView()
}

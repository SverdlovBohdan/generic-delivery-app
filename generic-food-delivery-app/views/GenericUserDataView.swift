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
            List {
                @Bindable var accountState = accountViewState
                if let accountSection {
                    accountSection($accountState)
                        .animation(.easeIn, value: accountViewState.error)
                }
            }
            
            List {
                @Bindable var orderState = orderViewState
                if let orderSection {
                    orderSection($orderState)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Update")) {
                    accountRepository.write(account: Customer(name: accountViewState.name,
                                                              phone: accountViewState.phone,
                                                              paymentMethod: accountViewState.paymentMethod,
                                                              addresses: accountViewState.addresses))
                    accountViewState.dispatch(action: .setValidationStatus(false))
                }
                .disabled(!canUpdateAccount)
            }
        }
    }
    
    private var canUpdateAccount: Bool {
        accountViewState.isValid ?? false
    }
}

typealias UserDataView = GenericUserDataView<AccountView, OrderView>

#Preview {
    UserDataView()
}

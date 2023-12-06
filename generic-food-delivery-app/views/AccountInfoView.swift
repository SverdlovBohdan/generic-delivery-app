//
//  AccountInfoView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 06.12.2023.
//

import SwiftUI

struct AccountInfoValidationPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct AccountInfoView: View {
    var editable: Bool
    
    @State private var accountViewState: AccountViewStateStore = .makeDefault()
    
    // TODO: Use DI
    private var accountRepository: AccountRepository = AccountUserDefaults()
    
    private var isAccountInfoValid: Bool {
        (accountViewState.isValid ?? false) || accountViewState.error == nil
    }
    
    private var isAddressKnown: Bool {
        !accountViewState.addresses.isEmpty
    }
    
    private var isAccountFulfilled: Bool {
        return isAccountInfoValid && isAddressKnown
    }
    
    init(editable: Bool = true) {
        self.editable = editable
    }
    
    var body: some View {
        @Bindable var accountState = accountViewState
        AccountSectionView(viewState: $accountState, editable: editable)
            .animation(.easeIn, value: accountViewState.error)
            .preference(key: AccountInfoValidationPreferenceKey.self, value: isAccountFulfilled)
        
        if editable {
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
    
    private var canUpdateAccount: Bool {
        accountViewState.isValid ?? false
    }
}

#Preview {
    Form {
        AccountInfoView()
    }
}

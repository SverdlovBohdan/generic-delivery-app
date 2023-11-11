//
//  AccountPresenter.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import Foundation
import SwiftUI

enum AccountAction: CustomStringConvertible {
    case update(Customer)
    case setValidationStatus(Bool)
    case setError(String)
    case changePaymentMethod(Customer.PaymentMethod)
    case setName(String)
    case setPhone(String)
    case resetError
    case addAddress(Customer.Address)
    case removeAddress(IndexSet)
    case changeDefaultAddress(Int)
    
    var description: String {
        switch self {
        case .update(let account):
            return "update(\(account.name))"
        case .changePaymentMethod(let method):
            return "changePaymentMethod(\(method))"
        case .setValidationStatus(let status):
            return "validStatus(\(status))"
        case .setError(let error):
            return "error(\(error))"
        case .setName(let name):
            return "setName(\(name))"
        case .setPhone(let email):
            return "setEmail(\(email))"
        case .resetError:
            return "resetError"
        case .removeAddress(let indexes):
            return "removeAddress \(indexes)"
        case .changeDefaultAddress(let index):
            return "changeDefaultAddress \(index)"
        default:
            return "AccountAction"
        }
    }
}

struct AccountState {
    var name: String = ""
    var phone: String = ""
    var paymentMethod: Customer.PaymentMethod = .card
    var isValid: Bool? = nil
    var error: String? = nil
    var addresses: [Customer.Address] = []
}

typealias AccountViewStateStore = ViewStateStore<AccountAction, AccountState>

func accountReducer(state: inout AccountState, action: AccountAction) -> Void {
    switch action {
    case .setPhone(let phone):
        state.phone = phone
    
    case .setName(let name):
        state.name = name
        
    case .changePaymentMethod(let method):
        state.paymentMethod = method
        
    case .update(let account):
        state.name = account.name
        state.phone = account.phone
        state.paymentMethod = account.paymentMethod
        state.addresses = account.addresses
        
    case .setValidationStatus(let status):
        state.isValid = status
        if status {
            state.error = nil
        }
        
    case .setError(let error):
        state.isValid = false
        state.error = error
    
    case .resetError:
        state.error = nil
        
    case .addAddress(let address):
        state.addresses.append(address)
        if state.addresses.count == 1 {
            state.addresses[0].isDefault = true
        }
        
    case .removeAddress(let indexSet):
        state.addresses.remove(atOffsets: indexSet)
        if !state.addresses.isEmpty && state.addresses.allSatisfy({ item in
            return !item.isDefault
        }) {
            state.addresses[0].isDefault = true
        }

    case .changeDefaultAddress(let index):
        guard !state.addresses.isEmpty else { return }
        guard index < state.addresses.count else { return }
        
        if let defaultAddressIndex = state.addresses.firstIndex(where: { address in
            return address.isDefault
        }) {
            state.addresses[defaultAddressIndex].isDefault = false
        }
        
        state.addresses[index].isDefault = true
    }
}

extension ViewStateStore where Action == AccountAction, State == AccountState {
    static func makeDefault() -> AccountViewStateStore {
        return AccountViewStateStore(initialState: AccountState(), reducer: accountReducer)
    }
}

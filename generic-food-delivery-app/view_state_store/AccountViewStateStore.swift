//
//  AccountViewStateStore.swift
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
        case let .update(account):
            "update(\(account.name))"
        case let .changePaymentMethod(method):
            "changePaymentMethod(\(method))"
        case let .setValidationStatus(status):
            "validStatus(\(status))"
        case let .setError(error):
            "error(\(error))"
        case let .setName(name):
            "setName(\(name))"
        case let .setPhone(email):
            "setEmail(\(email))"
        case .resetError:
            "resetError"
        case let .removeAddress(indexes):
            "removeAddress \(indexes)"
        case let .changeDefaultAddress(index):
            "changeDefaultAddress \(index)"
        default:
            "AccountAction"
        }
    }
}

struct AccountState {
    var name: String = ""
    var phone: String = ""
    var paymentMethod: Customer.PaymentMethod = .card
    var isValid: Bool?
    var error: String?
    var addresses: [Customer.Address] = []
}

typealias AccountViewStateStore = ViewStateStore<AccountAction, AccountState>

func accountReducer(state: inout AccountState, action: AccountAction) {
    switch action {
    case let .setPhone(phone):
        state.phone = phone

    case let .setName(name):
        state.name = name

    case let .changePaymentMethod(method):
        state.paymentMethod = method

    case let .update(account):
        state.name = account.name
        state.phone = account.phone
        state.paymentMethod = account.paymentMethod
        state.addresses = account.addresses

    case let .setValidationStatus(status):
        state.isValid = status
        if status {
            state.error = nil
        }

    case let .setError(error):
        state.isValid = false
        state.error = error

    case .resetError:
        state.error = nil

    case let .addAddress(address):
        state.addresses.append(address)
        if state.addresses.count == 1 {
            state.addresses[0].isDefault = true
        }

    case let .removeAddress(indexSet):
        state.addresses.remove(atOffsets: indexSet)
        if !state.addresses.isEmpty, state.addresses.allSatisfy({ item in
            !item.isDefault
        }) {
            state.addresses[0].isDefault = true
        }

    case let .changeDefaultAddress(index):
        guard !state.addresses.isEmpty else { return }
        guard index < state.addresses.count else { return }

        if let defaultAddressIndex = state.addresses.firstIndex(where: { address in
            address.isDefault
        }) {
            state.addresses[defaultAddressIndex].isDefault = false
        }

        state.addresses[index].isDefault = true
    }
}

extension ViewStateStore where Action == AccountAction, State == AccountState {
    static func makeDefault() -> AccountViewStateStore {
        AccountViewStateStore(initialState: AccountState(), reducer: accountReducer)
    }
}

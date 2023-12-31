//
//  AccountInfoView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import SwiftUI

struct AccountInfoView: View {
    @State private var viewState: AccountViewStateStore = .makeDefault()

    var updatable: Bool

    // TODO: Use DI
    private let accountRepository: AccountRepository = AccountUserDefaults()
    private let inputValidator: AccountUserInputValidator = AccountInteractor()

    private let disclaimer: String = .init("💡") + String(localized: "All data is stored on the device. Used only for auto-filling.")
    private let accountTitle: String = .init("🥸") + String(localized: "Account")
    private let paymentMethodTitle: String = .init("💳 ") + String(localized: "Payment method")
    private let addressesTitle: String = .init("🏡 ") + String(localized: "Addresses")

    var body: some View {
        Group {
            Section {
                Label(
                    title: { TextField(String(localized: "John Doe"), text: nameBinding) },
                    icon: { Text("🪪") }
                )

                Label(
                    title: { TextField(String(localized: "Phone number"), text: phoneBinding) },
                    icon: { Text("📞") }
                )

                Picker(paymentMethodTitle, selection: paymentMethodBindign) {
                    ForEach(Customer.PaymentMethod.allCases, id: \.self) { method in
                        Text(method.localized).tag(method)
                    }
                }

                if let error = viewState.error {
                    Text(error)
                        .foregroundStyle(Color.red)
                }
            } header: {
                Text(accountTitle)
            } footer: {
                Text(disclaimer)
            }

            Section {
                AddressesView(addresses: viewState.addresses) { addedAddress in
                    viewState.dispatch(action: .addAddress(addedAddress))
                    performInputValidation()
                } didRemove: { indexes in
                    viewState.dispatch(action: .removeAddress(indexes))
                    performInputValidation()
                } didDefaultChange: { index in
                    viewState.dispatch(action: .changeDefaultAddress(index))
                    performInputValidation()
                }
            } header: {
                HStack {
                    Text(addressesTitle)
                    Spacer()
                    Label(String(localized: "swipe to remove"), systemImage: "hand.point.up.left.and.text")
                }
            }
            .onAppear(perform: {
                viewState.dispatch(action: .update(accountRepository.read()))
            })

            if updatable {
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
        .preference(
            key: CustomerDataForOrderPreferenceKey.self,
            value: CustomerDataForOrderPreferenceKey
                .CustomerData(customer: Customer(name: viewState.name,
                                                 phone: viewState.phone,
                                                 paymentMethod: viewState.paymentMethod,
                                                 addresses: viewState.addresses), isValid: isAccountInfoValid)
        )
    }

    private func performInputValidation() {
        inputValidator.validate(name: viewState.name, phone: viewState.phone) { result in
            viewState.dispatch(action: .setValidationStatus(result.isSuccess))
        }
    }

    private var isAccountInfoValid: Bool {
        viewState.isValid ?? false
    }

    private var canUpdateAccount: Bool {
        viewState.isValid ?? false
    }

    private var paymentMethodBindign: Binding<Customer.PaymentMethod> {
        .init {
            viewState.paymentMethod
        } set: { newMethod in
            viewState.dispatch(action: .changePaymentMethod(newMethod))
            performInputValidation()
        }
    }

    private var nameBinding: Binding<String> {
        .init {
            viewState.name
        } set: { newName in
            if newName == viewState.name {
                return
            }

            viewState.dispatch(action: .setName(newName))

            inputValidator.validate(name: newName, phone: viewState.phone) { result in
                switch result {
                case .success:
                    viewState.dispatch(action: .setValidationStatus(true))
                case let .failure(error):
                    viewState.dispatch(action: .setValidationStatus(false))
                    inputValidator.validate(name: newName) { result in
                        let errorAction: AccountAction = result.isFailure ? .setError(error.localized) : .resetError
                        viewState.dispatch(action: errorAction)
                    }
                }
            }
        }
    }

    private var phoneBinding: Binding<String> {
        .init {
            viewState.phone
        } set: { newPhone in
            if newPhone == viewState.phone {
                return
            }

            viewState.dispatch(action: .setPhone(newPhone))

            inputValidator.validate(name: viewState.name, phone: newPhone) { result in
                switch result {
                case .success:
                    viewState.dispatch(action: .setValidationStatus(true))
                case let .failure(error):
                    viewState.dispatch(action: .setValidationStatus(false))
                    inputValidator.validate(phone: newPhone) { result in
                        let errorAction: AccountAction = result.isFailure ? .setError(error.localized) : .resetError
                        viewState.dispatch(action: errorAction)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        Form {
            AccountInfoView(updatable: true)
        }
    }
}

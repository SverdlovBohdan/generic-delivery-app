//
//  AccountInteractor.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import Foundation

class AccountInteractor: AccountUserInputValidator {
    func validate(name: String, sideEffect: SideEffect) {
        sideEffect(validate(name: name))
    }

    func validate(phone: String, sideEffect: SideEffect) {
        sideEffect(validate(phone: phone))
    }

    func validate(name: String, phone: String, sideEffect: SideEffect) {
        sideEffect(validate(name: name, phone: phone))
    }

    private func validate(phone: String) -> Result<Bool, AccountValidatorError> {
        if phone.isEmpty {
            return .failure(.emptyField)
        }

        return .success(true)
    }

    private func validate(name: String) -> Result<Bool, AccountValidatorError> {
        if name.isEmpty || name.allSatisfy(\.isWhitespace) {
            return .failure(.emptyField)
        }

        return .success(true)
    }

    private func validate(name: String, phone: String) -> Result<Bool, AccountValidatorError> {
        let nameValidationResult: Result<Bool, AccountValidatorError> = validate(name: name)
        if nameValidationResult.isFailure {
            return nameValidationResult
        }

        let emailValidationResult: Result<Bool, AccountValidatorError> = validate(phone: phone)
        if emailValidationResult.isFailure {
            return emailValidationResult
        }

        return .success(true)
    }
}

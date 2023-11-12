//
//  AccountInputValidator.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import Foundation

enum AccountValidatorError: Error {
    case emptyField
    case notPhone
    
    var localized: String {
        switch self {
        case .emptyField:
            return String(localized: "Empty field")
        case .notPhone:
            return String(localized: "Doesn't look like phone number")
        }
    }
}

protocol AccountUserInputValidator {
    typealias SideEffect = (Result<Bool, AccountValidatorError>) -> Void
    
    func validate(name: String, sideEffect: SideEffect) -> Void
    func validate(phone: String, sideEffect: SideEffect) -> Void
    func validate(name: String, phone: String, sideEffect: SideEffect) -> Void
}

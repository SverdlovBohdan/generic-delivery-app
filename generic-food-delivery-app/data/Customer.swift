//
//  Account.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import Foundation

struct Customer: Codable {
    enum PaymentMethod: CaseIterable, Codable {
        case cash
        case card
        
        var localized: String {
            switch self {
            case .cash:
                return String(localized: "Cash")
            case .card:
                return String(localized: "Card")
            }
        }
    }
    
    var name: String
    var phone: String
    var paymentMethod: PaymentMethod
    
    var addresses: [Address] = .init()
    
    var isAuthorized: Bool {
        return !phone.isEmpty
    }
}

extension Customer {
    struct Address: Codable, Identifiable, Hashable {
        var id: UUID = .init()

        var street: String
        var appartment: String
        var isDefault: Bool = false
        var isEmpty: Bool {
            return street.isEmpty
        }
        static let emptyAddress: Address = .init(street: "", appartment: "")
    }

    static var unknownUser: Customer = Customer(name: "", phone: "", paymentMethod: .cash)
}

//
//  Customer.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import Foundation

struct Customer: Codable, Equatable {
    enum PaymentMethod: CaseIterable, Codable {
        case cash
        case card

        var localized: String {
            switch self {
            case .cash:
                String(localized: "Cash")
            case .card:
                String(localized: "Card")
            }
        }
    }

    var name: String
    var phone: String
    var paymentMethod: PaymentMethod

    var addresses: [Address] = .init()

    var isAuthorized: Bool {
        !phone.isEmpty
    }
}

extension Customer {
    struct Address: Codable, Identifiable, Hashable {
        var id: UUID = .init()

        var street: String
        var appartment: String
        var isDefault: Bool = false
        var isEmpty: Bool {
            street.isEmpty
        }

        static let emptyAddress: Address = .init(street: "", appartment: "")
    }

    static var unknownUser: Customer = .init(name: "", phone: "", paymentMethod: .cash)
}

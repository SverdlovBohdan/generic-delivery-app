//
//  OrderUserDefaults.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 15.11.2023.
//

import Foundation

class OrderUserDefaults: OrderRepository {
    // TODO: Switch to DI
    private let orderDataBase: UserDefaults = .standard
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()

    func read() -> [ShoppingCartItem] {
        guard let orderRaw = performOrderRead() else {
            return []
        }

        do {
            return try performOrderDecode(orderRaw: orderRaw)
        } catch {
            // TODO: Add log message
            return []
        }
    }

    func write(order: [ShoppingCartItem]) {
        guard let orderRaw = try? encoder.encode(order) else { return }
        orderDataBase.set(orderRaw, forKey: UserDefaultsNames.orderKey)
    }

    /// For unit tests only.
    fileprivate func performOrderRead() -> Data? {
        orderDataBase.data(forKey: UserDefaultsNames.orderKey)
    }

    fileprivate func performOrderDecode(orderRaw: Data) throws -> [ShoppingCartItem] {
        try decoder.decode([ShoppingCartItem].self, from: orderRaw)
    }
}

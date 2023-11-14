//
//  AccountUserDefaults.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import Foundation

class AccountUserDefaults: AccountRepository {
    // TODO: Switch to DI
    private let accountDataBase: UserDefaults = .standard
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()

    func read() -> Customer {
        guard let accountRaw = performAccountRead() else {
            return .unknownUser
        }

        do {
            return try performAccountDecode(accountRaw: accountRaw)
        } catch {
            // TODO: Add log message
            return .unknownUser
        }
    }

    func write(account: Customer) {
        guard let accountRaw = try? encoder.encode(account) else { return }
        accountDataBase.set(accountRaw, forKey: UserDefaultsNames.accountKey)
    }

    /// For unit tests only.
    fileprivate func performAccountRead() -> Data? {
        accountDataBase.data(forKey: UserDefaultsNames.accountKey)
    }

    fileprivate func performAccountDecode(accountRaw: Data) throws -> Customer {
        try decoder.decode(Customer.self, from: accountRaw)
    }
}

//
//  AccountRepository.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import Foundation

protocol AccountRepository {
    func read() -> Customer
    func write(account: Customer) -> Void
}

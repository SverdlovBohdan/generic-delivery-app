//
//  ProductsCatalog.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation
import SwiftUI

protocol ProductsCatalog {
    typealias SideEffect = (Result<[ProductItem], RepositoryError>) -> Void

    func getAvailableProducts(sideEffect: SideEffect) async -> Void
}

//
//  ResourcesPath.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

protocol ResourcesPath {
    var categories: String { get }
    var products: String { get }
}

extension ResourcesPath {
    var categories: String { "api/categories?lang=ukrainian" }
    var products: String { "api/products?lang=ukrainian&withChildren=true&type=1" }
}

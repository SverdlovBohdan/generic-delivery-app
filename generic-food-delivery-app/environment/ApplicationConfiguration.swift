//
//  ApplicationConfiguration.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

protocol ApplicationConfiguration {
    var baseUrl: String { get }
}

extension ApplicationConfiguration {
    var baseUrl: String { "https://vilki-palki.od.ua" } 
}

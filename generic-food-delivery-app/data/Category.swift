//
//  Category.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

struct Category: Decodable {
    var id: Int
    var name: String
    var slug: String
    var children: [SubCategory]

    enum CodingKeys: String, CodingKey {
        case name = "name_ua"

        case id
        case slug
        case children
    }
}

extension Category {
    struct SubCategory: Decodable {
        var id: Int
    }
}

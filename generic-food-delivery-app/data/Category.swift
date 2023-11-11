//
//  Categories.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

struct Category: Decodable {
    var id: Int
    var name: String
    var slug: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name_ua"
        
        case id
        case slug
    }
}

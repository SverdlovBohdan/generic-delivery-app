//
//  Product.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

struct ProductItem: Codable, Identifiable {
    var id: UUID = UUID()

    var remoteId: Int
    var name: String
    var description: String
    var price: Float
    var weight: Float
    var iikoId: String
    var slug: String
    var mainImage: MainImage
    var category: Category
    
    enum CodingKeys: String, CodingKey {
        case remoteId = "id"
        case description = "description_ua"
        case name = "name_ua"
        case iikoId = "iiko_id"
        case mainImage = "main_image"
        
        case price
        case weight
        case slug
        case category
    }
}

extension ProductItem {
    struct MainImage: Codable {
        var url: String
        
        enum CodingKeys: String, CodingKey {
            case url = "urlForList"
        }
    }
    
    struct Category: Codable {
        var id: Int
    }
}

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
    var backgroundImage: BackgroundImage
    var category: Category
    var hide: Int
    var visible: Bool {
        return hide == 0
    }
    
    enum CodingKeys: String, CodingKey {
        case remoteId = "id"
        case description = "description_ua"
        case name = "name_ua"
        case iikoId = "iiko_id"
        case mainImage = "main_image"
        case backgroundImage = "background_image"
        
        case price
        case weight
        case slug
        case category
        case hide
    }
}

extension ProductItem {
    struct MainImage: Codable {
        var url: String
        
        enum CodingKeys: String, CodingKey {
            case url = "urlForList"
        }
    }
    
    struct BackgroundImage: Codable {
        var url: String
        
        enum CodingKeys: String, CodingKey {
            case url = "urlForList"
        }
    }
    
    struct Category: Codable {
        var id: Int
    }
    
    #if DEBUG
    static let preview: ProductItem = .init(remoteId: 13, name: "Boul chicken", description: "Boul chicken Boul chicken Boul chicken",
                                            price: 178.0000, weight: 300, iikoId: "", slug: "", mainImage: .init(url: ""),
                                            backgroundImage: .init(url: ""), category: .init(id: 13), hide: 0)
    #endif
}

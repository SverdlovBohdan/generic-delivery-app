//
//  IdToEmojiiMapper.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

protocol CategoryDataGetter {
    func getEmoji(id: Int) -> String
    func getCategoryName(id: Int) async -> String
}

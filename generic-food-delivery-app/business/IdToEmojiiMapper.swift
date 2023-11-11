//
//  IdToEmojiiMapper.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 11.11.2023.
//

import Foundation

protocol IdToEmojiiMapper {
    func map(id: Int) -> String
}

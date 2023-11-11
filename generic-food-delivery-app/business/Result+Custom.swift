//
//  Result+Custom.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import Foundation

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
}

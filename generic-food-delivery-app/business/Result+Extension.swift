//
//  Result+Extension.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 30.10.2023.
//

import Foundation

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success:
            true
        case .failure:
            false
        }
    }

    var isFailure: Bool {
        !isSuccess
    }
}

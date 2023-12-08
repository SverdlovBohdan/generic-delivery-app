//
//  CategorySectionHeaderView.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 13.11.2023.
//

import SwiftUI

struct CategorySectionHeaderView: View {
    var categoryId: Int

    // TODO: Use DI
    private let categoryData: CategoryDataGetter = Restaraunt.shared

    @State private var name: String = ""

    var body: some View {
        HStack {
            Text(categoryData.getEmoji(id: categoryId))
            Text(name)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            Spacer()
        }
        .font(.title)
        .task {
            name = await categoryData.getCategoryName(id: categoryId)
        }
    }
}

#Preview {
    CategorySectionHeaderView(categoryId: 13)
}

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
    private var categoryData: CategoryDataGetter = Restaraunt.shared

    @State private var name: String = ""

    init(categoryId: Int) {
        self.categoryId = categoryId
    }

    var body: some View {
        HStack {
            Text(categoryData.getEmoji(id: categoryId))
            Text(name)
                .padding([.leading, .trailing], 8)
                .padding([.top, .bottom], 4)
                .background(Color.gray.opacity(0.05))
                .clipShape(Capsule())
                .overlay {
                    Capsule().stroke(
                        Color.gray.opacity(0.05))
                        .shadow(radius: 6)
                }
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

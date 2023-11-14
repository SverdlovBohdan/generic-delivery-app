//
//  ButtonSyles.swift
//  generic-food-delivery-app
//
//  Created by Bohdan Sverdlov on 13.11.2023.
//

import SwiftUI

struct GrowingButton<ClippedShape: Shape>: ButtonStyle {
    var clipShape: ClippedShape

    private var leadingTrailingPadding: CGFloat
    private var topBottomPadding: CGFloat
    private var foregroundColor: Color = .white
    private var backgroundColor: Color = .blue

    init(clipShape: ClippedShape, leadingTrailingPadding: CGFloat = 8, topBottomPadding: CGFloat = 4,
         foregroundColor: Color = .white, backgroundColor: Color = .blue)
    {
        self.clipShape = clipShape
        self.leadingTrailingPadding = leadingTrailingPadding
        self.topBottomPadding = topBottomPadding
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.leading, .trailing], leadingTrailingPadding)
            .padding([.top, .bottom], topBottomPadding)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(clipShape)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

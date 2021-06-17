//
//  FloatingButtonStyle.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.7 : 1)
            .animation(.easeIn(duration: 0.1))
            .frame(width: 40, height: 40)
            .padding(3)
            .foregroundColor(.accentColor)
            .contentShape(Rectangle())
    }
}

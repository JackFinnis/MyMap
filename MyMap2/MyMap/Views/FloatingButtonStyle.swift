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
            .frame(width: 30, height: 30, alignment: .center)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeIn(duration: 0.1))
            .frame(width: 40, height: 40, alignment: .center)
            .foregroundColor(.accentColor)
    }
}

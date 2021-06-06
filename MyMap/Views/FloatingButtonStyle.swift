//
//  FloatingButtonStyle.swift
//  MyMap
//
//  Created by Finnis on 06/06/2021.
//

import SwiftUI

struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 10, height: 10)
            .padding()
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

//
//  View.swift
//  MyMap
//
//  Created by Jack Finnis on 11/01/2023.
//

import SwiftUI

struct Background: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var background: Material { colorScheme == .light ? .regularMaterial : .thickMaterial }
    
    func body(content: Content) -> some View {
        content
            .background(background)
            .cornerRadius(10)
            .compositingGroup()
            .shadow(color: Color(.systemFill), radius: 5)
    }
}

extension View {
    func materialBackground() -> some View {
        self.modifier(Background())
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ applyModifier: Bool = true, @ViewBuilder content: (Self) -> Content) -> some View {
        if applyModifier {
            content(self)
        } else {
            self
        }
    }
    
    func horizontallyCentred() -> some View {
        HStack {
            Spacer(minLength: 0)
            self
            Spacer(minLength: 0)
        }
    }
    
    func bigButton() -> some View {
        self
            .font(.body.bold())
            .padding()
            .horizontallyCentred()
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(15)
    }
}

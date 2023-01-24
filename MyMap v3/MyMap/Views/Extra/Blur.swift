//
//  Blur.swift
//  MyMap
//
//  Created by Jack Finnis on 24/01/2023.
//

import SwiftUI

struct Blur: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

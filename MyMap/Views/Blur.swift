//
//  Blur.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

// Blur a view
struct Blur: UIViewRepresentable {
    
    var style: UIBlurEffect.Style = .regular
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        uiView.effect = UIBlurEffect(style: style)
    }
}

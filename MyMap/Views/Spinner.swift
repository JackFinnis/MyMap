//
//  Spinner.swift
//  MyMap
//
//  Created by Finnis on 24/04/2021.
//

import SwiftUI

struct Spinner: UIViewRepresentable {
    
    let isAnimating: Bool

    func makeUIView(context: UIViewRepresentableContext<Spinner>) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.color = UIColor(.gray)
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Spinner>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

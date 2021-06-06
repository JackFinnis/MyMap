//
//  Spinner.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct Spinner: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Spinner>) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.color = UIColor.systemGray
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Spinner>) {
        uiView.startAnimating()
    }
}

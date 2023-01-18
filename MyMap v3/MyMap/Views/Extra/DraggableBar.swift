//
//  DraggableBar.swift
//  Change
//
//  Created by Jack Finnis on 29/10/2022.
//

import SwiftUI

struct DraggableBar: View {
    let title: String?
    
    init(_ title: String? = nil) {
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(width: 35, height: 5)
                .foregroundColor(Color(.placeholderText))
                .cornerRadius(2.5)
            Spacer(minLength: 0)
            if let title {
                Text(title)
                    .font(.headline)
                Spacer(minLength: 0)
            }
        }
    }
}

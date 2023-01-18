//
//  DismissCross.swift
//  Change
//
//  Created by Jack Finnis on 20/10/2022.
//

import SwiftUI

struct DismissCross: View {
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.title2)
            .foregroundStyle(.secondary, Color(.tertiarySystemFill))
    }
}

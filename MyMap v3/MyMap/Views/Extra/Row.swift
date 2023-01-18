//
//  Row.swift
//  Petition
//
//  Created by Jack Finnis on 19/08/2021.
//

import SwiftUI

struct Row<Leading: View, Trailing: View>: View {
    let leading: () -> Leading
    let trailing: () -> Trailing
    
    var body: some View {
        HStack {
            leading()
            Spacer()
            trailing()
        }
    }
}

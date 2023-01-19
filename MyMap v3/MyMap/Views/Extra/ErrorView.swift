//
//  ErrorView.swift
//  News
//
//  Created by Jack Finnis on 13/01/2023.
//

import SwiftUI

struct ErrorView: View {
    let systemName: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemName)
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            VStack(spacing: 5) {
                Text(title)
                    .font(.title3.bold())
                Text(message)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(systemName: "heart.slash", title: "Health Unavailable", message: "\(NAME) needs access to the Health App to store and load workouts. Unfortunately, this device does not have these capabilities so the app will not work.")
    }
}

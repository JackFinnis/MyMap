//
//  ToggleStateButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

struct ToggleStateButton: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    
    var body: some View {
        Button(action: {
            newWorkoutManager.toggleWorkoutState()
        }, label: {
            Image(systemName: newWorkoutManager.toggleStateImageName)
                .foregroundColor(Color(UIColor.systemBackground))
                .frame(width: 54, height: 54)
                .padding(3)
        })
    }
}

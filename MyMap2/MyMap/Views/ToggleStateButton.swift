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
                .frame(width: 40, height: 40)
                .padding(3)
        })
    }
}

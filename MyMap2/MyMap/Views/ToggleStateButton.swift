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
                .font(.title)
                .padding(.vertical, 15)
                .padding(.leading, 15)
                .padding(.trailing, 10)
        })
    }
}

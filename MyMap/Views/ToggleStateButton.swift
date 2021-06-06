//
//  ToggleStateButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

struct ToggleStateButton: View {
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        Button(action: {
            workoutManager.toggleWorkoutState()
        }, label: {
            Image(systemName: workoutManager.toggleStateImageName)
                .font(.title)
                .padding(.vertical, 15)
                .padding(.leading, 15)
                .padding(.trailing, 10)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

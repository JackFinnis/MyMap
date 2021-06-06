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
    
    var toggleStateImageName: String {
        if workoutManager.workoutState == .running {
            return "pause.fill"
        } else {
            return "play.fill"
        }
    }
    
    var body: some View {
        Button(action: {
            updateWorkoutState()
        }, label: {
            Image(systemName: toggleStateImageName)
            .font(.title)
            .padding(.vertical, 15)
            .padding(.leading, 15)
            .padding(.trailing, 10)
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    func updateWorkoutState() {
        if workoutManager.workoutState == .running {
            workoutManager.pauseWorkout()
        } else {
            workoutManager.resumeWorkout()
        }
    }
}

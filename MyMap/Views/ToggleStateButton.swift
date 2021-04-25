//
//  ToggleStateButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

struct ToggleStateButton: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var workoutState: WorkoutState
    
    var body: some View {
        Button(action: {
            updateWorkoutState()
        }, label: {
            if workoutState == .running {
                // Show pause button
                Image(systemName: "pause.fill")
                    .font(.title)
                    .padding(10)
            } else {
                // Show play button
                Image(systemName: "play.fill")
                    .font(.title)
                    .padding(10)
            }
        })
        .foregroundColor(Color(UIColor.white))
        .background(Color(UIColor.systemBackground))
    }
    
    func updateWorkoutState() {
        if workoutState == .running {
            // Pause workout
            workoutState = .paused
            workoutManager.pauseWorkout()
        } else {
            // Resume workout
            workoutState = .running
            workoutManager.resumeWorkout()
        }
    }
}

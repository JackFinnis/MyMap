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
            HStack {
                if workoutState == .running {
                    // Show pause button
                    Image(systemName: "pause.fill")
                } else {
                    // Show play button
                    Image(systemName: "play.fill")
                }
            }
            .font(.title)
            .padding(.vertical, 15)
            .padding(.leading, 15)
            .padding(.trailing, 10)
        })
        .buttonStyle(PlainButtonStyle())
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

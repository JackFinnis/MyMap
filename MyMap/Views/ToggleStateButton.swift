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
            if workoutState == .running {
                // Pause workout
                workoutState = .paused
                workoutManager.pauseWorkout()
            } else {
                // Resume workout
                workoutState = .running
                workoutManager.resumeWorkout()
            }
        }, label: {
            HStack {
                if workoutState == .running {
                    // Show pause button
                    Text("Pause")
                    Image(systemName: "pause.fill")
                } else {
                    // Show play button
                    Text("Resume")
                    Image(systemName: "play.fill")
                }
            }
            .padding()
            .foregroundColor(Color(UIColor.black))
            .background(Color(UIColor.white))
        })
        .cornerRadius(20)
    }
}

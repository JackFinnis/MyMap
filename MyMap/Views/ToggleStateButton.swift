//
//  ToggleStateButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

struct ToggleStateButton: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        
        Button(action: {
            if workoutManager.state == .paused {
                // Resume workout
                workoutManager.resumeWorkout()
            } else {
                // Pause workout
                workoutManager.pauseWorkout()
            }
        }, label: {
            if workoutManager.state == .paused {
                // Show play button
                HStack {
                    Text("Resume")
                    Image(systemName: "play.fill")
                }
                .padding()
                .foregroundColor(Color(UIColor.black))
                .background(Color(UIColor.white))
            } else {
                // Show pause button
                HStack {
                    Text("Pause")
                    Image(systemName: "pause.fill")
                }
                .padding()
                .foregroundColor(Color(UIColor.black))
                .background(Color(UIColor.white))
            }
        })
        .cornerRadius(20)
    }
}

//
//  FloatingStateView.swift
//  MyMap
//
//  Created by Finnis on 04/03/2021.
//

import SwiftUI

struct FloatingStateView: View {
    
    // Access environment object workout manager
    @EnvironmentObject var workoutManager: WorkoutManager
    
    // The workout state
    @State var workoutState: WorkoutState = .notStarted
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("\(elapsedTimeString(elapsed: secondsToMinutesSeconds(seconds: workoutManager.elapsedSeconds)))")
                HStack {
                    if workoutState == .notStarted {
                        // Just display start button
                        StartButton(workoutState: $workoutState)
                    } else {
                        // Display toggle state and end button
                        ToggleStateButton(workoutState: $workoutState)
                        EndButton(workoutState: $workoutState)
                    }
                }
            }
            .padding()
            .background(Blur())
            .cornerRadius(30)
            .shadow(radius: 5, y: 5)
            .padding()
        }
    }
    
    // Convert the seconds into seconds and minutes
    func secondsToMinutesSeconds(seconds: Int) -> (Int, Int) {
        return (seconds / 60, seconds % 60)
    }
    
    // Convert the seconds, minutes, hours into a string.
    func elapsedTimeString(elapsed: (m: Int, s: Int)) -> String {
        return String(format: "%02d:%02d", elapsed.m, elapsed.s)
    }
}

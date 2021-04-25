//
//  WorkoutStatusBar.swift
//  MyMap
//
//  Created by Finnis on 04/03/2021.
//

import SwiftUI
import MapKit

struct WorkoutStatusBar: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @Binding var userTrackingMode: MKUserTrackingMode
    
    @State var workoutState: WorkoutState = .notStarted
    @State var workoutDetailIsPresented: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                if workoutManager.state != .notStarted {
                    workoutDetailIsPresented = true
                }
            }, label: {
                VStack {
                    HStack {
                        HStack {
                            Spacer()
                            Text(elapsedTimeString(elapsed: secondsToMinutesSeconds(seconds: workoutManager.elapsedSeconds)))
                                .font(.headline)
                            Spacer()
                        }
                        
                        if workoutState == .notStarted {
                            // Just display start button
                            StartButton(workoutState: $workoutState, userTrackingMode: $userTrackingMode)
                        } else {
                            // Display toggle state and end button
                            ToggleStateButton(workoutState: $workoutState)
                            EndButton(workoutState: $workoutState)
                        }
                        
                        HStack {
                            Spacer()
                            Text("2.58 km")
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
            })
            .padding(10)
            .background(Color(UIColor.white))
            .compositingGroup()
            .shadow(radius: 2)
            .buttonStyle(PlainButtonStyle())
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

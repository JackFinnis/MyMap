//
//  WorkoutStatusBar.swift
//  MyMap
//
//  Created by Finnis on 04/03/2021.
//

import SwiftUI
import MapKit

struct WorkoutStatusBar: View {
    
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    @EnvironmentObject var workoutsSortBy: WorkoutsSortBy
    
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var workoutState: WorkoutState
    
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
                            HStack {
                                ToggleStateButton(workoutState: $workoutState)
                                Divider()
                                    .frame(height: 62)
                                EndButton(workoutState: $workoutState)
                            }
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(11)
                        }
                        
                        HStack {
                            Spacer()
                            Text(totalDistanceString(metres: Int(workoutManager.distance)))
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
            })
            .padding(10)
            .background(Blur())
            .compositingGroup()
            .shadow(radius: 2)
            .buttonStyle(PlainButtonStyle())
        }
        .sheet(isPresented: $workoutDetailIsPresented) {
            WorkoutDetail()
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
    
    func totalDistanceString(metres: Int) -> String {
        return String("\(metres / 1000).\(metres % 1000) km")
    }
}

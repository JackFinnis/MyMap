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
    
    @Binding var userTrackingMode: MKUserTrackingMode
    
    @State var showWorkoutDetailSheet: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                if workoutManager.workoutState != .notStarted {
                    showWorkoutDetailSheet = true
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
                        
                        if workoutManager.workoutState == .notStarted {
                            // Just display start button
                            StartButton(userTrackingMode: $userTrackingMode)
                        } else {
                            HStack {
                                ToggleStateButton()
                                Divider()
                                    .frame(height: 62)
                                EndButton()
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
        .sheet(isPresented: $showWorkoutDetailSheet) {
            WorkoutDetail()
        }
    }
    
    // MARK: - Helper Functions
    // Convert seconds to seconds and minutes
    func secondsToMinutesSeconds(seconds: Int) -> (Int, Int) {
        return (seconds / 60, seconds % 60)
    }
    
    // Convert seconds, minutes and hours to a string.
    func elapsedTimeString(elapsed: (m: Int, s: Int)) -> String {
        return String(format: "%02d:%02d", elapsed.m, elapsed.s)
    }
    
    // Convert metres to a string
    func totalDistanceString(metres: Int) -> String {
        return String("\(metres / 1000).\(metres % 1000) km")
    }
}

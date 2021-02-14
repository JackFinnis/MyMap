//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI

struct WorkoutView: View {
    
    // Access environment object workout manager
    @EnvironmentObject var workoutManager: WorkoutManager
    
    // Setup HealthKit
    var healthKitSetupAssistant = HealthKitSetupAssistant()
    
    var body: some View {
        
        ZStack {
            
            MapView()
            
            VStack {
                
                Spacer()
                
                VStack {
                    
                    Text("\(elapsedTimeString(elapsed: secondsToHoursMinutesSeconds(seconds: workoutManager.elapsedSeconds)))")
                    
                    HStack {
                        
                        if workoutManager.state == .notStarted {
                            // Just display start button
                            StartButton()
                        } else {
                            // Display toggle state and end button
                            ToggleStateButton()
                            EndButton()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
        }.onAppear {
            
            healthKitSetupAssistant.requestAuthorisation()
        }
    }
    
    // Convert the seconds into seconds, minutes, hours.
    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    // Convert the seconds, minutes, hours into a string.
    func elapsedTimeString(elapsed: (h: Int, m: Int, s: Int)) -> String {
        return String(format: "%d:%02d:%02d", elapsed.h, elapsed.m, elapsed.s)
    }
}

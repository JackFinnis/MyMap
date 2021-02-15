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
    
    // Access map manager business logic
    var mapManager = MapManager()
    
    // Setup HealthKit
    var healthKitSetupAssistant = HealthKitSetupAssistant()
    
    var body: some View {
        
        ZStack {
            
            MapView()
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                VStack {
                    
                    Text("\(elapsedTimeString(elapsed: secondsToMinutesSeconds(seconds: workoutManager.elapsedSeconds)))")
                    
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
                .background(Blur())
                .cornerRadius(30)
                .shadow(radius: 5, y: 5)
                .padding()
            }
        }
        .onAppear {
            
            healthKitSetupAssistant.requestAuthorisation()
        }
    }
    
    // Convert the seconds into seconds and minutes
    func secondsToMinutesSeconds (seconds: Int) -> (Int, Int) {
      return (seconds / 60, seconds % 60)
    }
    
    // Convert the seconds, minutes, hours into a string.
    func elapsedTimeString(elapsed: (m: Int, s: Int)) -> String {
        return String(format: "%02d:%02d", elapsed.m, elapsed.s)
    }
}

/* Old
 
VStack {

    Text("")
        .frame(width: UIScreen.main.bounds.width, height:  UIApplication.shared.statusBarFrame.height)
        .background(Blur())
        .ignoresSafeArea()
    
    Spacer()
}
 
*/

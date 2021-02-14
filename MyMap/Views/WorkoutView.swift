//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI

struct WorkoutView: View {
    
    // Access the business logic:
    @ObservedObject var workoutManager = WorkoutManager()
    
    // Setup HealthKit
    var healthKitSetupAssistant = HealthKitSetupAssistant()
    
    var body: some View {
        
        VStack {
            
            Text("\(workoutManager.elapsedSeconds)")
            
            Button("Start workout") {
                
                workoutManager.startWorkout()
            }
            Button("Pause workout") {
                
                workoutManager.pauseWorkout()
            }
            Button("Resume workout") {
                
                workoutManager.resumeWorkout()
            }
            Button("Finish workout") {
                
                workoutManager.endWorkout()
            }
        }.onAppear {
            
            healthKitSetupAssistant.requestAuthorisation()
        }
    }
}

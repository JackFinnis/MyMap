//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI

struct WorkoutView: View {
    
    // Access workout data store
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    
    // Setup HealthKit
    var healthKitSetupAssistant = HealthKitSetupAssistant()
    
    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            
            FloatingStateView()
        }
        .onAppear {
            // Setup HealthKit
            healthKitSetupAssistant.requestAuthorisation()
            // Setup workout data store
            workoutDataStore.loadAllWorkoutRoutes()
        }
    }
}

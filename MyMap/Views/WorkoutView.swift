//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI
import MapKit

struct WorkoutView: View {
    // Workout manager business logic
    @StateObject var workoutManager = WorkoutManager()
    // Heath store data
    @StateObject var workoutDataStore = WorkoutDataStore()
    // Workout filters
    @StateObject var workoutsFilter = WorkoutsFilter()
    // Map settings manager
    @StateObject var mapManager = MapManager()
    
    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            FloatingMapButtons()
            WorkoutStatusBar()
        }
        .onAppear {
            // Setup HealthKit
            HealthKitSetupAssistant().requestAuthorisation()
            // Setup workout data store
            workoutDataStore.loadWorkoutsData()
        }
        .environmentObject(workoutManager)
        .environmentObject(workoutDataStore)
        .environmentObject(workoutsFilter)
        .environmentObject(mapManager)
    }
}

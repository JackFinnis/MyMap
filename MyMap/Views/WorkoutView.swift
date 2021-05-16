//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI
import MapKit

struct WorkoutView: View {
    
    // Access environment object workout manager
    @EnvironmentObject var workoutManager: WorkoutManager
    
    // Access workout data store
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    
    // Workout filters
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    
    // Workout State
    @State var workoutState: WorkoutState = .notStarted
    
    // Map Settings
    @State var userTrackingMode: MKUserTrackingMode = .follow
    @State var mapType: MKMapType = .standard
    
    // Find closest route
    @State var findClosestRoute: Bool = false
    
    // Setup HealthKit
    var healthKitSetupAssistant = HealthKitSetupAssistant()
    
    var body: some View {
        ZStack {
            MapView(workoutState: $workoutState, mapType: $mapType, userTrackingMode: $userTrackingMode, findClosestRoute: $findClosestRoute)
                .ignoresSafeArea()
            
            Button("Find Closest Route") {
                findClosestRoute.toggle()
            }
            
            FloatingMapButtons(workoutState: $workoutState, mapType: $mapType, userTrackingMode: $userTrackingMode)
            
            WorkoutStatusBar(userTrackingMode: $userTrackingMode, workoutState: $workoutState)
        }
        .onAppear {
            // Setup HealthKit
            healthKitSetupAssistant.requestAuthorisation()
            
            // Setup workout data store
            workoutDataStore.loadAllWorkoutRoutes()
        }
    }
}

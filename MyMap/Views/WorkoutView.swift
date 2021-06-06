//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI
import MapKit

struct WorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    
    // Map Settings
    @State var userTrackingMode: MKUserTrackingMode = .follow
    @State var mapType: MKMapType = .standard
    
    @State var workoutState: WorkoutState = .notStarted
    
    // Find closest route
    @State var findClosestRoute: Bool = false
    
    var body: some View {
        ZStack {
            MapView(workoutState: $workoutState, mapType: $mapType, userTrackingMode: $userTrackingMode, findClosestRoute: $findClosestRoute)
                .ignoresSafeArea()
            
            FloatingMapButtons(workoutState: $workoutState, mapType: $mapType, userTrackingMode: $userTrackingMode, findClosestRoute: $findClosestRoute)
            
            WorkoutStatusBar(userTrackingMode: $userTrackingMode, workoutState: $workoutState)
        }
        .onAppear {
            // Setup HealthKit
            HealthKitSetupAssistant().requestAuthorisation()
            
            // Setup workout data store
            workoutDataStore.loadAllWorkoutRoutes()
        }
    }
}

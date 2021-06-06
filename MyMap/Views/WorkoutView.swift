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
    @State var searchState: WorkoutSearchState = .none
    
    var body: some View {
        ZStack {
            MapView(mapType: $mapType, userTrackingMode: $userTrackingMode, searchState: $searchState)
                .ignoresSafeArea()
            
            FloatingMapButtons(mapType: $mapType, userTrackingMode: $userTrackingMode, searchState: $searchState)
            
            WorkoutStatusBar(userTrackingMode: $userTrackingMode)
        }
        .onAppear {
            // Setup HealthKit
            HealthKitSetupAssistant().requestAuthorisation()
            
            // Setup workout data store
            workoutDataStore.loadAllWorkoutRoutes()
        }
    }
}
